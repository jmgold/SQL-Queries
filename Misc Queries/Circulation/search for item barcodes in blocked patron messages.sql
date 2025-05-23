/*
Jeremy Goldstein
Minuteman Library Network

Finds item barcodes contained in the message fields of patrons with manual blocks
*/

SELECT 
p.id,
p.mblock_code,
SUBSTRING(v.field_content, '3\d{13}') AS item_barcode,
v.field_content AS message
FROM
sierra_view.patron_record p
JOIN
sierra_view.varfield v
ON
p.id = v.record_id AND v.varfield_type_code = 'm' AND p.mblock_code != '-' AND v.field_content ~ '^.*3\d{13}'

ORDER BY 1