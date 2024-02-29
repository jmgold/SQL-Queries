/*
Jeremy Goldstein
Minuteman Library Network

Provides details of virtual records in the system where there is not a local copy title with the same title & author
Within Mass these are all items borrowed via the Commonwealth Catalog using AutoGraphics ILL
*/
WITH COMCAT AS (
SELECT
title.field_content AS title,
author.field_content AS author,
COUNT(rmi.id) AS record_count,
COUNT(DISTINCT b.field_content) AS unique_barcode_count,
MAX(rmi.creation_date_gmt::DATE) AS recent_item_creation_date
--rmi.record_last_updated_gmt AS item_last_updated_date,
--b.field_content AS barcode,
--callnum.field_content AS call_number

FROM
sierra_view.record_metadata rmi
JOIN
sierra_view.varfield b
ON
rmi.id = b.record_id AND b.varfield_type_code = 'b'
JOIN
sierra_view.varfield callnum
ON
rmi.id = callnum.record_id AND callnum.varfield_type_code = 'c'
JOIN
sierra_view.bib_record_item_record_link l
ON
rmi.id = l.item_record_id
JOIN
sierra_view.record_metadata rmb
ON
l.bib_record_id = rmb.id
JOIN
sierra_view.varfield title
ON
rmb.id = title.record_id AND title.varfield_type_code = 't'
JOIN
sierra_view.varfield author
ON
rmb.id = author.record_id AND author.varfield_type_code = 'a'
JOIN
sierra_view.item_record_property bp
ON
rmi.id = bp.item_record_id

WHERE
rmi.campus_code = 'ncip' AND rmi.record_type_code = 'i'

GROUP BY 1,2
)

SELECT
DISTINCT comcat.*

FROM 
comcat
LEFT JOIN
sierra_view.bib_record_property b
ON
comcat.title||comcat.author = b.best_title||b.best_author
LEFT JOIN
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id AND rm.campus_code = ''

WHERE
rm.id IS NULL

ORDER BY 3 DESC
