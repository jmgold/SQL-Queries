/*
Jeremy Goldstein
Minuteman Library Network
Retrives order records with an on hold status across all accounting units
*/

SELECT 
	rm.record_type_code||rm.record_num||'a' AS order_number,
	o.accounting_unit_code_num AS accounting_unit,
	rm.creation_date_gmt::DATE AS creation_Date

FROM 
sierra_view.order_record o
JOIN
sierra_view.record_metadata rm
ON
o.id = rm.id

WHERE 
o.order_status_code = '2'
