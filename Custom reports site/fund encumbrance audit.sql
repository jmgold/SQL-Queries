/*
Jeremy Goldstein
Minuteman Library Network

compares current funds to values of open orders and paid invoices 
*/

--Gather total price of open order records for each fund 
WITH order_encumbrance AS
(SELECT
fm.code,
ROUND(SUM(o.estimated_price * (cmf.copies - COALESCE(op.copies,0))),2)::MONEY AS encumbrance_orders

FROM
sierra_view.order_record o
JOIN
sierra_view.order_record_cmf cmf
ON
o.id = cmf.order_record_id AND cmf.location_code != 'multi'
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
o.accounting_unit_code_num = {{accounting_unit}}
AND o.order_status_code IN ('o','q','g','c')

GROUP BY 1)

SELECT
*,
'' AS "FUND ENCUMBRANCE AUDIT",
'' AS "https://sic.minlib.net/reports/56"
FROM
(SELECT
DISTINCT f.fund_code,
fn.name AS "name",
ROUND(CAST(f.encumbrance AS NUMERIC (12,2))/100,2)::MONEY AS encumbrance,
COALESCE(oe.encumbrance_orders,0::MONEY) AS order_encumbrance,
ROUND(CAST(f.encumbrance AS NUMERIC (12,2))/100,2)::MONEY - COALESCE(oe.encumbrance_orders,0::MONEY) AS difference

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
fm.id = fp.fund_master_id AND fp.fund_type_id = '1'
JOIN
sierra_view.fund_property_name fn
ON
fp.id = fn.fund_property_id
LEFT JOIN
order_encumbrance oe
ON
fm.code = oe.code

WHERE
f.acct_unit = {{accounting_unit}}
AND f.fund_type = 'fbal'

ORDER BY 1
)a