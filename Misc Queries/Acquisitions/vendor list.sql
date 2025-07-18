/*
Jeremy Goldstein
Minuteman Library Network
Gathers full list of vendor records for an accounting unit
*/

SELECT
rm.record_type_code||rm.record_num||'a' AS record_num,
v.code,
var.field_content AS name

FROM sierra_view.vendor_record v
JOIN sierra_view.varfield var
  ON v.id = var.record_id AND var.varfield_type_code = 't'
JOIN sierra_view.record_metadata rm
  ON v.id = rm.id

WHERE v.accounting_unit_code_num = '35'

ORDER BY 2