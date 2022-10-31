SELECT DISTINCT
rm.record_type_code||rm.record_num||'a' AS bib_number,
b.best_title AS title,
m.name AS mat_type,
rmp.record_type_code||rmp.record_num||'a' AS patron_number,
h.placed_gmt::DATE AS date_placed,
CASE
	WHEN h.is_frozen = TRUE THEN 'True'
	ELSE 'False'
END AS is_frozen,
h.expires_gmt::DATE AS expiration_date

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.varfield v
ON
l.item_record_id = v.record_id AND v.varfield_type_code = 'v'
JOIN
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id
JOIN
sierra_view.material_property_myuser m
ON
b.material_code = m.code
JOIN
sierra_view.hold h
ON b.bib_record_id = h.record_id
JOIN
sierra_view.record_metadata rmp
ON
h.patron_record_id = rmp.id

WHERE h.pickup_location_code ~ '{{location}}' 