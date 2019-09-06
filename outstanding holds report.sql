/*
Jeremy Goldstein
Minuteman Library Network

View Outstanding Holds Report
*/

SELECT
DISTINCT h.id,
h.placed_gmt::DATE AS date_placed,
h.expires_gmt AS date_expires,
pn.last_name||', '||pn.first_name||' '||pn.middle_name AS name,
ID2RECKEY(h.patron_record_id)||'a' AS patron_number,
(SELECT
pp.phone_number
FROM
sierra_view.patron_record_phone pp
WHERE
h.patron_record_id = pp.patron_record_id
ORDER BY pp.display_order
LIMIT 1) AS phone,
b.best_title AS title,
i.call_number_norm AS call_number,
h.pickup_location_code,
h.status

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
JOIN
sierra_view.bib_record_item_record_link l
ON
(rm.id = l.bib_record_id AND rm.record_type_code = 'b') OR (rm.id = l.item_record_id AND rm.record_type_code = 'i')
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
LEFT JOIN
sierra_view.item_record_property i
ON
rm.id = i.item_record_id AND rm.record_type_code = 'i'

WHERE
--h.status = '0'
h.pickup_location_code ~ '^act'
AND h.placed_gmt < '2019-08-06'