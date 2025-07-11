/*
Jeremy Goldstein
Minuteman Library Network
Retrieves order records without parents
*/

SELECT
  rm.record_type_code||rm.record_num||'a' AS onumber,
  o.accounting_unit_code_num,
  o.estimated_price,
  o.order_status_code,
  v.varfield_type_code,
  v.field_content

FROM sierra_view.order_record o
LEFT JOIN sierra_view.bib_record_order_record_link l
  ON o.id = l.order_record_id
JOIN sierra_view.record_metadata rm
  ON o.id = rm.id
LEFT JOIN sierra_view.varfield v
  ON o.id = v.record_id
  AND v.varfield_type_code = 'b'

WHERE l.order_record_id IS NULL