/*
Jeremy Goldstein
Minuteman Library Network

Provides details of virtual records in the system
Within Mass these are all items borrowed via the Commonwealth Catalog using AutoGraphics ILL
*/

SELECT
b.best_title AS title,
b.best_author AS author,
COUNT(rmi.id) AS record_count,
COUNT(DISTINCT i.barcode) AS unique_barcode_count,
MAX(rmi.creation_date_gmt::DATE) AS recent_item_creation_date
--rmi.record_last_updated_gmt AS item_last_updated_date,
--i.barcode AS barcode,
--i.call_number AS call_number

FROM
sierra_view.record_metadata rmi
JOIN
sierra_view.item_record_property i
ON
rmi.id = i.item_record_id AND rmi.campus_code = 'ncip'
JOIN
sierra_view.bib_record_item_record_link l
ON
rmi.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id

GROUP BY 1,2
ORDER BY 3 DESC, 5 DESC