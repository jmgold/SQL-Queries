/*
Jeremy Goldstein
Minuteman Library Network

compares current funds to values of open orders and paid invoices 
*/

SELECT
DISTINCT f.fund_code,
STRING_AGG(DISTINCT TRIM(fn.name), ', ') AS NAME,
ROUND(CAST(f.appropriation AS NUMERIC (12,2))/100,2)::MONEY AS appropriation,
ROUND(CAST(f.expenditure AS NUMERIC (12,2))/100,2)::MONEY AS expenditure,
COALESCE(invoice_expenditure.invoice_total,0::MONEY) AS expenditure_invoices,
COALESCE(invoice_expenditure.invoice_total,0::MONEY) - ROUND(CAST(f.expenditure AS NUMERIC (12,2))/100,2)::MONEY AS expentiture_difference,
ROUND(CAST(f.encumbrance AS NUMERIC (12,2))/100,2)::MONEY AS encumbrance,
COALESCE(order_encumbrance.encumbrance_orders,0::MONEY) AS encumbrance_orders,
COALESCE(order_encumbrance.encumbrance_orders,0::MONEY) - ROUND(CAST(f.encumbrance AS NUMERIC (12,2))/100,2)::MONEY AS encumbrance_difference,
ROUND(CAST((f.appropriation - f.expenditure - f.encumbrance) AS NUMERIC (12,2))/100,2)::MONEY AS "free balance",
ROUND(CAST((f.appropriation - f.expenditure) AS NUMERIC (12,2))/100,2)::MONEY AS "cash balance"

FROM
sierra_view.fund f
JOIN
sierra_view.accounting_unit a
ON
f.acct_unit = a.code_num
JOIN
sierra_view.fund_master fm
ON
f.fund_code = fm.code AND fm.accounting_unit_id = a.id
JOIN
sierra_view.fund_property fp
ON
fm.id = fp.fund_master_id
JOIN
sierra_view.fund_property_name fn
ON
fp.id = fn.fund_property_id
JOIN
sierra_view.order_record o
ON
a.code_num = o.accounting_unit_code_num AND o.order_status_code IN ('o','q','g','d')
JOIN
sierra_view.order_record_cmf cmf
ON
o.id = cmf.order_record_id
LEFT JOIN
(SELECT
fm.code,
ROUND(SUM(o.estimated_price * (cmf.copies - COALESCE(op.copies,0))),2)::MONEY AS encumbrance_orders

FROM
sierra_view.order_record o
JOIN
sierra_view.order_record_cmf cmf
ON
o.id = cmf.order_record_id
JOIN
sierra_view.accounting_unit a
ON
o.accounting_unit_code_num = a.code_num
JOIN
sierra_view.fund_master fm
ON
fm.code_num = cmf.fund_code::INT AND fm.accounting_unit_id = a.id
LEFT JOIN
sierra_view.order_record_paid op
ON
o.id = op.order_record_id AND o.order_status_code = 'q'

WHERE
o.accounting_unit_code_num = '5'
AND o.order_status_code IN ('o','q','g','d')

GROUP BY 1) order_encumbrance
ON
fm.code = order_encumbrance.code
LEFT JOIN (
SELECT
fm.code,
SUM(il.paid_amt)::MONEY AS invoice_total

FROM
sierra_view.invoice_record i
JOIN
sierra_view.invoice_record_line il
ON
i.id = il.invoice_record_id
JOIN
sierra_view.accounting_unit a
ON
i.accounting_unit_code_num = a.code_num
JOIN
sierra_view.fund_master fm
ON
il.fund_code::INT = fm.code_num AND a.id = fm.accounting_unit_id

WHERE
a.code_num = '5'
AND i.paid_date_gmt >= NOW() - INTERVAL '1 year'
AND CASE
	WHEN DATE_TRUNC('MONTH',NOW())::DATE >= TO_DATE(TO_CHAR(NOW()::DATE,'yyyy-07-01'),'yyyy-mm-dd') THEN i.invoice_date_gmt >= TO_DATE(TO_CHAR(NOW()::DATE,'yyyy-07-01'),'yyyy-mm-dd')
	ELSE i.invoice_date_gmt >= TO_DATE(TO_CHAR((NOW()-INTERVAL '1 YEAR')::DATE,'yyyy-07-01'),'yyyy-mm-dd')
	END

GROUP BY 1) invoice_expenditure
ON
fm.code = invoice_expenditure.code

WHERE
f.acct_unit = '5'
AND f.fund_type = 'fbal'

GROUP BY 1,3,4,5,6,7,8,9,10,11
ORDER BY 1