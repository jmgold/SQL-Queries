--Jeremy Goldstein
--Minuteman Library Network

--Summary of invoice payments posted in a selected time period
--Originally created for Tracy Babiasz at Chapel Hill Public Library

SELECT
	i.invoice_number_text AS "INVOICE",
	DATE(i.invoice_date_gmt) AS "INVOICE DATE",
	v.vendor_code AS "VENDOR",
	i.subtotal_amt AS "SUBTOTAL",
	i.shipping_amt AS "SERVICE CHARGE",
	i.total_tax_amt AS "TAX",
	i.grand_total_amt AS "INVOICE AMT"
FROM
	sierra_view.invoice_record i
JOIN
	sierra_view.invoice_record_vendor_summary v
	ON
	i.id = v.invoice_record_id

WHERE i.posted_data_gmt BETWEEN '2019-03-01' AND '2019-03-19'
ORDER BY i.invoice_number_text
;