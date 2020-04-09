/*
Jeremy Goldstein
Minuteman Library Network

Returns details for holds at a pickup location
Filters for pickup location, hold placed date and hold status
*/

WITH in_transit AS (
SELECT
ir.id,
SPLIT_PART(v.field_content,': ',1) AS transit_timestamp,
pickup_loc.name AS origin_loc
FROM
sierra_view.item_record ir
JOIN
sierra_view.varfield v
ON
ir.id = v.record_id AND v.varfield_type_code = 'm'
JOIN
sierra_view.location_myuser pickup_loc
ON
SUBSTRING(SPLIT_PART(SPLIT_PART(v.field_content,'from ',2),' to',1)FROM 1 FOR 3) = pickup_loc.code
WHERE
ir.item_status_code = 't'
)

SELECT *
FROM(
SELECT
DISTINCT h.id AS hold_id,
h.placed_gmt::DATE AS date_placed,
id2reckey(h.patron_record_id)||'a' AS patron_number,
pn.last_name||', '||pn.first_name||' '||pn.middle_name AS name,
b.best_title AS title,
rec_num.record_type_code||rec_num.record_num||'a' AS record_number,
pickup_loc.name AS pickup_location,
CASE
	WHEN h.is_frozen = 'true' THEN 'Frozen'
	WHEN h.status = '0' THEN 'On hold'
	WHEN h.status = 't' THEN 'In transit'
	ELSE 'Ready for pickup'
	END AS hold_status,
CASE
	WHEN h.record_id = l.bib_record_id THEN 'bib'
	ELSE 'item'
	END AS hold_type,
REPLACE(REPLACE(i.call_number,'|a',''),'|f','') AS call_number,
ir.location_code AS item_location,
t.transit_timestamp AS in_transit_time,
t.origin_loc AS in_transit_origin,
rm.record_last_updated_gmt::DATE AS on_holdshelf_date
FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.bib_record_id OR h.record_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
LEFT JOIN
sierra_view.item_record_property i
ON
l.item_record_id = i.item_record_id AND h.record_id = l.item_record_id
JOIN
sierra_view.patron_record_fullname pn
ON
h.patron_record_id = pn.patron_record_id
LEFT JOIN
sierra_view.item_record ir
ON
i.item_record_id = ir.id
LEFT JOIN
in_transit t
ON
h.record_id = t.id AND ir.item_status_code = 't'
LEFT JOIN
sierra_view.record_metadata rm
ON
ir.id = rm.id AND h.status NOT IN ('0','t')
JOIN
sierra_view.record_metadata rec_num
ON
h.record_id = rec_num.id
JOIN
sierra_view.location_myuser pickup_loc
ON
SUBSTRING(h.pickup_location_code,1,3) = pickup_loc.code

WHERE h.placed_gmt::DATE BETWEEN {{start_date}} AND {{end_date}}
AND h.pickup_location_code ~ {{location}}
)inner_query
--values are 'In transit', 'Ready for pickup', 'On hold'
WHERE inner_query.hold_status IN ({{hold_status}})

ORDER BY 2,1