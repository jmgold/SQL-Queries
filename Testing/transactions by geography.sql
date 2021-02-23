SELECT
--{{geo}},
CASE
	WHEN stateid.content IS NULL THEN 'no data'
	WHEN stateid.content = '' THEN stateid.content
	ELSE stateid.content||county.content||tract.content||SUBSTRING(block.content,1,1)
END AS geoid,
/*Possible options
SUBSTRING(a.postal_code,'^\d{5}') AS zip_code

CASE
	WHEN stateid.content IS NULL THEN 'no data'
	WHEN stateid.content = '' THEN stateid.content
	ELSE stateid.content||county.content||tract.content||SUBSTRING(block.content,1,1)
END AS geoid

CASE
	WHEN stateid.content IS NULL THEN 'no data'
	WHEN stateid.content = '' THEN stateid.content
	ELSE stateid.content||county.content||tract.content
END AS geoid

CASE
	WHEN stateid.content IS NULL THEN 'no data'
	WHEN stateid.content = '' THEN stateid.content
	ELSE stateid.content||county.content
END AS geoid
*/
--COUNT(DISTINCT p.id) FILTER(WHERE o.id IS NOT NULL) AS patron_w_current_checkout_count,
--COUNT(DISTINCT o.id) AS current_checkout_count,
COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'i' AND t.due_date_gmt::DATE > t.transaction_gmt::DATE) AS "5_week_overdue_checkin",
--COUNT(DISTINCT o.id) FILTER(WHERE o.due_gmt::DATE < CURRENT_DATE) AS current_overdue_count,
--COUNT(DISTINCT p.id) FILTER(WHERE h.id IS NOT NULL) AS patron_w_current_hold_count,
--COUNT(DISTINCT h.id) AS current_hold_count,
COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'o') AS "5_week_checkout_count",
COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'o' AND sg.location_code = SUBSTRING(t.item_location_code,1,3)) AS "5_week_local_checkout_count",
COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'o' AND sg.location_code != SUBSTRING(t.item_location_code,1,3)) AS "5_week_network_checkout_count",
COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'f') AS "5_week_filled_hold_count",
COUNT(DISTINCT t.id) FILTER(WHERE t.op_code ~ '^n|h') AS "5_week_hold_placed_count"
--COUNT(DISTINCT h.id) FILTER(WHERE h.placed_gmt::DATE >= (CURRENT_DATE - 35)) AS "5_week_hold_placed_count"

FROM
sierra_view.patron_record p
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id
AND a.patron_record_address_type_id = '1'
/*LEFT JOIN
sierra_view.hold h
ON
p.id = h.patron_record_id
LEFT */JOIN
sierra_view.circ_trans t
ON
p.id = t.patron_record_id
--for census field
LEFT JOIN
sierra_view.subfield stateid
ON
stateid.record_id = p.id AND stateid.field_type_code = 'k' AND stateid.tag = 's'
LEFT JOIN
sierra_view.subfield county
ON
county.record_id = p.id AND county.field_type_code = 'k' AND county.tag = 'c'
LEFT JOIN
sierra_view.subfield tract
ON
tract.record_id = p.id AND tract.field_type_code = 'k' AND tract.tag = 't'
LEFT JOIN
sierra_view.subfield block
ON
block.record_id = p.id AND block.field_type_code = 'k' AND block.tag = 'b'
/*LEFT JOIN
sierra_view.checkout o
ON
p.id = o.patron_record_id
LEFT*/ JOIN
sierra_view.statistic_group_myuser sg
ON
t.stat_group_code_num = sg.code
JOIN
sierra_view.bib_record_item_record_link l
ON
/*(h.record_id = l.bib_record_id OR h.record_id = l.item_record_id) OR*/ t.bib_record_id = l.bib_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id AND b.material_code IN ('5','u')--({{mat_type}})

WHERE p.ptype_code IN ('2')--({{ptype}})
GROUP BY 1
ORDER BY 2 DESC