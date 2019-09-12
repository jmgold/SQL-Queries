/*
Jeremy Goldstein
Minuteman Library Network

Identifies old outstanding holds that are soon to expire 
*/

SELECT
DISTINCT h.id AS hold_id,
h.placed_gmt::DATE AS date_placed,
h.expires_gmt AS date_expires,
pn.last_name||', '||pn.first_name||' '||pn.middle_name AS name,
ID2RECKEY(h.patron_record_id)||'a' AS patron_number,
barcode.field_content AS barcode,
COALESCE((SELECT
pp.phone_number
FROM
sierra_view.patron_record_phone pp
WHERE
h.patron_record_id = pp.patron_record_id
ORDER BY pp.display_order
LIMIT 1),'none') AS phone,
COALESCE(email.field_content,'none') AS email,
b.best_title AS title,
id2reckey(b.bib_record_id)||'a' AS bib_number,
CASE
	WHEN rm.record_type_code = 'i' THEN 'item hold'
	ELSE 'bib hold'
END AS hold_type,
COUNT(i.id) AS available_item_count

FROM
sierra_view.hold h
JOIN
sierra_view.record_metadata rm
ON
h.record_id = rm.id AND rm.campus_code = ''
JOIN
sierra_view.patron_record_fullname pn
ON
h.patron_record_id = pn.patron_record_id
LEFT JOIN
sierra_view.bib_record_item_record_link l
ON
(rm.id = l.bib_record_id AND rm.record_type_code = 'b') OR (rm.id = l.item_record_id AND rm.record_type_code = 'i')
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
LEFT JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.is_available_at_library = true
JOIN
sierra_view.varfield barcode
ON
h.patron_record_id = barcode.record_id AND barcode.varfield_type_code = 'b'
LEFT JOIN
sierra_view.varfield email
ON
h.patron_record_id = email.record_id AND email.varfield_type_code = 'z'


WHERE
--h.status = '0'
h.pickup_location_code ~ '^cam'
AND h.expires_gmt - NOW() < '5 days'
AND h.status = '0'

GROUP BY 1,2,3,4,5,6,7,8,9,10,11
ORDER BY 4