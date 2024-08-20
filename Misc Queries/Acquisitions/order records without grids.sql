/*
Jeremy Goldstein
Minuteman Library Network
identifies order records across accounting units that lack a location code, and which were likely downloaded from a vendor without applying a grid
Assums records without location codes are the marker of this behavior, typically this would also be true of vendor and fund codes.
*/
SELECT 
rm.record_type_code||rm.record_num||'a' AS record_number,
cmf.location_code AS location,
o.accounting_unit_code_num AS accounting_unit,
rm.creation_date_gmt::DATE AS created_date
  
FROM
sierra_view.order_record o 
JOIN
sierra_view.order_record_cmf cmf
ON
o.id = cmf.order_record_id
JOIN
sierra_view.record_metadata rm
ON
o.id = rm.id

WHERE 
cmf.location_code = 'none'

