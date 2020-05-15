WITH order_dates AS (
SELECT
DISTINCT o.id,
p.invoice_date_gmt::DATE AS ship_date,
p.paid_date_gmt::DATE AS paid_date,
TO_DATE(SUBSTRING(sent.field_content, '\d{2}\-\d{2}\-\d{4}'),'MM-DD-YYYY') AS sent_date

FROM
sierra_view.order_record o
JOIN
sierra_view.order_record_paid p
ON
o.id = p.order_record_id
JOIN
sierra_view.varfield sent
ON
o.id = sent.record_id AND sent.varfield_type_code = 'b' AND TO_DATE(SUBSTRING(sent.field_content, '\d{2}\-\d{2}\-\d{4}'),'MM-DD-YYYY') IS NOT NULL
JOIN
sierra_view.record_metadata rm
ON
o.id = rm.id AND rm.creation_date_gmt::DATE >= '07-01-2018'

WHERE o.accounting_unit_code_num = '12'
)

SELECT
o.vendor_record_code AS vendor_code,
n.field_content AS vendor_name,
SUM(cmf.copies) AS copies_ordered,
COALESCE(SUM(p.copies),0) AS copies_received,
COALESCE(SUM(cmf.copies) FILTER(WHERE o.order_status_code = 'z'),'0') - COALESCE(SUM(p.copies) FILTER(WHERE o.order_status_code = 'z'),0) AS copies_cancelled,
COALESCE(SUM(p.paid_amount),'0')::MONEY AS total_paid,
COALESCE(SUM(p.paid_amount)/SUM(p.copies),'0')::MONEY AS price_per_copy,
COALESCE(ROUND(AVG(ship_date - sent_date))::VARCHAR,'') AS avg_days_to_ship,
COALESCE(ROUND(AVG(paid_date - sent_date))::VARCHAR,'') AS avg_days_to_invoice

FROM
sierra_view.order_record o
JOIN
sierra_view.vendor_record v
ON
o.vendor_record_code = v.code AND o.accounting_unit_code_num = v.accounting_unit_code_num
JOIN
sierra_view.varfield n
ON
v.id = n.record_id AND n.varfield_type_code = 't'
JOIN
sierra_view.order_record_cmf cmf
ON
o.id = cmf.order_record_id AND cmf.display_order = '0'
JOIN
sierra_view.record_metadata rm
ON
o.id = rm.id AND rm.creation_date_gmt::DATE >= '07-01-2018'
LEFT JOIN
sierra_view.order_record_paid p
ON
o.id = p.order_record_id
LEFT JOIN order_dates od
ON
o.id = od.id

WHERE o.accounting_unit_code_num = '12'
GROUP BY 1,2

UNION

SELECT
'TOTAL' AS vendor_code,
'' AS vendor_name,
SUM(cmf.copies) AS copies_ordered,
SUM(p.copies) AS copies_received,
SUM(cmf.copies) FILTER(WHERE o.order_status_code = 'z') - SUM(p.copies) FILTER(WHERE o.order_status_code = 'z') AS copies_cancelled,
SUM(p.paid_amount)::MONEY AS total_paid,
(SUM(p.paid_amount)/SUM(p.copies))::MONEY AS price_per_copy,
'' AS avg_days_to_ship,
'' AS avg_days_to_invoice

FROM
sierra_view.order_record o
JOIN
sierra_view.vendor_record v
ON
o.vendor_record_code = v.code AND o.accounting_unit_code_num = v.accounting_unit_code_num
JOIN
sierra_view.varfield n
ON
v.id = n.record_id AND n.varfield_type_code = 't'
JOIN
sierra_view.order_record_cmf cmf
ON
o.id = cmf.order_record_id AND cmf.display_order = '0'
JOIN
sierra_view.record_metadata rm
ON
o.id = rm.id AND rm.creation_date_gmt::DATE >= '07-01-2018'
LEFT JOIN
sierra_view.order_record_paid p
ON
o.id = p.order_record_id
LEFT JOIN order_dates od
ON
o.id = od.id

WHERE o.accounting_unit_code_num = '12'
GROUP BY 1,2

ORDER BY 1