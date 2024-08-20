WITH circ_status AS (
	SELECT
		rmi.record_num,
		CASE
			WHEN co.id IS NOT NULL THEN 'CHECKED OUT'
			WHEN h.status IN ('b','j','i','t') THEN 
			CASE
				WHEN h.status IN ('b','j','i') THEN 'READY FOR PICKUP'
				WHEN h.status = 't' THEN  'IN TRANSIT TO PICKUP LOCATION'
			END
			WHEN h.status = '0' THEN 'UNFILLED HOLD'
			WHEN i.item_status_code = 't' THEN 'IN TRANSIT TO OWNING LOCATION'
			ELSE 'AVAILABLE'
		END AS circ_status,
		CASE
			WHEN co.id IS NOT NULL THEN co.checkout_gmt
			WHEN h.status IN ('b','j','i') THEN h.on_holdshelf_gmt
			WHEN (h.status = 't' OR i.item_status_code = 't') THEN rmi.record_last_updated_gmt
		END AS circ_action_gmt,
		CASE
			WHEN co.id IS NOT NULL THEN co.due_gmt
			WHEN h.status IN ('b','j','i') THEN h.expire_holdshelf_gmt
		END AS end_time_gmt,
		CASE
			---must convert loan rules to locations
			WHEN co.id IS NOT NULL THEN sg.name
			WHEN h.status IN ('b','j','i') THEN h.pickup_location_code
			WHEN (h.status = 't' OR i.item_status_code = 't')
				THEN SUBSTRING(SPLIT_PART(SPLIT_PART(v.field_content,'from ',2),' to',1)FROM 1 FOR 3)
			ELSE i.location_code
		END AS last_location
	FROM
	sierra_view.record_metadata rmi
	JOIN
	sierra_view.item_record i
	ON
	rmi.id = i.id
	LEFT JOIN
	sierra_view.checkout co
	ON
	rmi.id = co.item_record_id
	LEFT JOIN
	sierra_view.hold h
	ON
	rmi.id = h.record_id
	LEFT JOIN sierra_view.varfield v
	ON
	i.id = v.record_id AND v.varfield_type_code = 'm' AND v.field_content LIKE '%IN TRANSIT%' AND i.item_status_code = 't'
	LEFT JOIN sierra_view.circ_trans t
	ON
	co.item_record_id = t.item_record_id AND co.patron_record_id = t.patron_record_id AND co.loanrule_code_num = t.loanrule_code_num AND t.op_code = 'o'
	JOIN
	sierra_view.statistic_group_myuser sg
	ON
	t.stat_group_code_num = sg.code
	LIMIT 1000
)

SELECT
	json_build_object (
	'record_num',record_num,
	'circ_status',circ_status,
	'circ_action_gmt',extract(epoch from circ_action_gmt)::INTEGER,
	'end_time_gmt',extract(epoch from end_time_gmt)::INTEGER,
	'last_location',last_location
	)
FROM
	circ_status
