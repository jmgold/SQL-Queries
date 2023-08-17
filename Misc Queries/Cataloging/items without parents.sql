/*
Jeremy Goldstein
Minuteman Library Network

identifies items without parents in the system
*/

SELECT
rm.record_type_code||rm.record_num||'a' AS inumber,
i.location_code,
ip.call_number,
ip.barcode,
rm.record_last_updated_gmt::DATE AS last_updated
  
FROM
sierra_view.item_record i
LEFT JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id

WHERE l.item_record_id IS NULL
  