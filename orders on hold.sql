--Retrieves order records from across accounting units with a status on on hold, indicating a problem with the order record.
SELECT 
	record_num AS "order_number",
	accounting_unit_code_num AS "accounting_unit",
	order_status_code AS "status", 
	record_creation_date_gmt AS "Creation_Date"

FROM sierra_view.order_view
WHERE 
	order_status_code = '1'
