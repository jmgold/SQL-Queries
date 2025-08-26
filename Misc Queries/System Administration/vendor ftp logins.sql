/*
Jeremy Goldstein
Minuteman Library Network

Pulls FTP info fields from vendor records to assist with troubleshooting
*/

SELECT
  v.accounting_unit_code_num,
  v.code,
  SPLIT_PART(var.field_content,'$',1) AS URL,
  SPLIT_PART(var.field_content,'$',2) AS user_name,
  SPLIT_PART(var.field_content,'$',3) AS pw

FROM sierra_view.vendor_record v
JOIN sierra_view.varfield var
  ON v.id = var.record_id AND var.varfield_type_code = 'g'

ORDER BY 1,2