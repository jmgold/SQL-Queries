/*
Jeremy Goldstein
Minuteman Library Network

Identifies items with a status of on holdshelf that are not on hold
*/

SELECT
i.location_code AS shelving_location,
id2reckey(i.id)||'a' AS item_number,
rm.record_last_updated_gmt::DATE AS last_updated,
ip.call_number_norm AS call_number,
ip.barcode,
b.best_title AS title,
b.best_author AS author

FROM
sierra_view.item_record i
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id AND rm.campus_code = ''
LEFT JOIN
sierra_view.hold h
ON
rm.id = h.record_id
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id

WHERE
i.item_status_code = '!'
AND h.record_id IS NULL
AND i.location_code ~ '{{location}}'
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.

ORDER BY 1,4
