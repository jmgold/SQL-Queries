/*
Jeremy Goldstein
Minuteman Library network

Identify records received via comcat

*/


SELECT *
FROM
sierra_view.item_record i
JOIN
sierra_view.record_metadata M
ON i.id = m.id AND m.campus_code = 'ncip'
LEFT JOIN
sierra_view.checkout c
ON
i.id = c.item_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id