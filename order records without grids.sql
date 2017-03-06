
--identifies order records across accounting units that lack a location code, and which were likely downloaded from a vendor without applying a grid
SELECT 
  order_view.record_num AS "Record_number",
  order_record_cmf.location_code AS "Location",
  order_view.accounting_unit_code_num AS "accounting unit",
  order_view.record_creation_date_gmt AS "created date"
FROM   sierra_view.order_view 
  JOIN sierra_view.order_record_cmf
     ON order_view.record_id=order_record_cmf.order_record_id
WHERE 
  order_record_cmf.location_code = 'none'

