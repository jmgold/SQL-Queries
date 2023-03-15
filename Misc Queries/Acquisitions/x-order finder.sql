/*
Jeremy Goldstien
Minuteman Library Network

Finds entries for x-order records on invoices
*/
SELECT
inumber,
invoice_number,
fund_code,
fund_name,
subfund,
vendor_code,
note,
invoice_date,
paid_date,
copies,
order_paid_amt,
invoice_shipping,
invoice_tax,
invoice_total
FROM
(
SELECT DISTINCT ON (1,2,3)
ID2RECKEY(i.id)||'a' AS inumber,
i.invoice_number_text AS invoice_number,
l.id AS line_id,
f.code AS fund_code,
n.name AS fund_name,
l.subfund_num AS subfund,
l.vendor_code AS vendor_code,
COALESCE(l.title,'') AS title,
l.note,
i.invoice_date_gmt::DATE AS invoice_date,
i.paid_date_gmt::DATE AS paid_date,
COALESCE(l.copies_paid_cnt::VARCHAR,'') AS copies,
l.paid_amt::MONEY AS order_paid_amt,
i.shipping_amt::MONEY AS invoice_shipping,
i.total_tax_amt::MONEY AS invoice_tax,
i.grand_total_amt::MONEY AS invoice_total

FROM
sierra_view.invoice_record_line l
JOIN
sierra_view.invoice_record i
ON
l.invoice_record_id = i.id
JOIN
sierra_view.fund_master f
ON
l.fund_code::INTEGER = f.code_num
JOIN
sierra_view.fund_myuser n
ON
f.id = n.fund_master_id

WHERE
l.order_record_metadata_id IS NULL
AND i.paid_date_gmt BETWEEN '2019-01-01' AND '2019-08-23'
AND i.accounting_unit_code_num = '35'
ORDER BY 1,2,3)a
