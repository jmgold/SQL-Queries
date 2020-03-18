/*
Jeremy Goldstein
Minuteman Library Network
version of Sierra's vendor statistics using both order and payment data for calculations
*/

WITH order_dates AS(
SELECT
DISTINCT o.id,
o.vendor_record_code AS vendor_code,
n.field_content AS vendor_name,
p.invoice_date_gmt::DATE AS ship_date,
p.paid_date_gmt::DATE AS paid_date,
TO_DATE(SUBSTRING(sent.field_content, '\d{2}\-\d{2}\-\d{4}'),'MM-DD-YYYY') AS sent_date,
p.copies,
p.paid_amount,
(p.paid_amount/p.copies) AS price_per_copy

FROM
sierra_view.order_record o
JOIN
sierra_view.order_record_paid p
ON
o.id = p.order_record_id
JOIN
sierra_view.vendor_record v
ON
o.vendor_record_code = v.code AND o.accounting_unit_code_num = v.accounting_unit_code_num
JOIN
sierra_view.varfield n
ON
v.id = n.record_id AND n.varfield_type_code = 't'
JOIN
sierra_view.varfield sent
ON
o.id = sent.record_id AND sent.varfield_type_code = 'b' AND TO_DATE(SUBSTRING(sent.field_content, '\d{2}\-\d{2}\-\d{4}'),'MM-DD-YYYY') IS NOT NULL


WHERE o.accounting_unit_code_num = {{accounting_unit}} 
	AND o.order_status_code = 'a'
	AND p.paid_date_gmt::DATE >= p.invoice_date_gmt::DATE 
	AND p.invoice_date_gmt::DATE >= TO_DATE(SUBSTRING(sent.field_content, '\d{2}\-\d{2}\-\d{4}'),'MM-DD-YYYY')
	AND TO_DATE(SUBSTRING(sent.field_content, '\d{2}\-\d{2}\-\d{4}'),'MM-DD-YYYY') >= {{sent_date}}
)

SELECT
od.vendor_code,
od.vendor_name,
SUM(od.copies) AS total_copies,
SUM(od.paid_amount)::MONEY AS total_paid,
AVG(od.price_per_copy)::MONEY AS avg_price,
ROUND(AVG(ship_date - sent_date)) AS avg_days_to_ship,
ROUND(AVG(paid_date - sent_date)) AS avg_days_to_invoice

FROM
order_dates od
GROUP BY 1,2
ORDER BY 1