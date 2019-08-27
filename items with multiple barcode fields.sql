/*Jeremy Goldstein
Minuteman Library Network

items with multiple barcode fields
*/

SELECT 
id2reckey(i.id)||'a' AS item_record_num,
barcode1.field_content,
barcode2.field_content

FROM
sierra_view.item_record AS i

JOIN
sierra_view.varfield		AS barcode1
ON
  barcode1.record_id = i.id
  AND barcode1.varfield_type_code = 'b'
JOIN
sierra_view.varfield		AS barcode2
ON
  barcode2.record_id = i.id
  AND barcode2.varfield_type_code = 'b'
  AND barcode2.occ_num > barcode1.occ_num
  

WHERE
i.location_code LIKE 'som%'

