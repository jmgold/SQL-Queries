/*
Jeremy Goldstein
Minuteman Library Network

Search for x-orders included in invoices from a given date range and accounting unit
*/
SELECT 
	ID2RECKEY(i.id)||'a' AS inumber,
	i.invoice_number_text AS invoice_number,
	f.code AS fund_code,
	l.vendor_code AS vendor_code,
	l.note,
	i.invoice_date_gmt::DATE AS invoice_date,
	i.paid_date_gmt::DATE AS paid_date,
	l.paid_amt::MONEY AS order_paid_amt,
	i.shipping_amt::MONEY AS invoice_shipping,
	i.total_tax_amt::MONEY AS invoice_tax,
	i.grand_total_amt::MONEY AS invoice_total

FROM sierra_view.invoice_record_line l
JOIN sierra_view.invoice_record i
	ON l.invoice_record_id = i.id
JOIN sierra_view.accounting_unit a
	ON i.accounting_unit_code_num = a.code_num
JOIN sierra_view.fund_master f
	ON l.fund_code::INTEGER = f.code_num AND a.id = f.accounting_unit_id

WHERE
l.order_record_metadata_id IS NULL
AND i.invoice_date_gmt BETWEEN '2023-10-01' AND '2023-12-31'
AND i.accounting_unit_code_num = '5'
ORDER BY 7,2
