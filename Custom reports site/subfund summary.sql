/*
Jeremy Goldstein
Minuteman Library Network

Gathers the current expenditure and encumbrance totals for each fund, broken out by subfund.
*/
WITH order_encumbrance AS
(SELECT
fm.code,
o.ocode2 AS subfund,
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
o.accounting_unit_code_num = {{accounting_unit}}
AND o.order_status_code IN ('o','q','g','d')

GROUP BY 1,2)

SELECT
fm.code AS fund_code,
fn.name AS fund_name,
sub.code AS subfund,
COALESCE(oe.encumbrance_orders,0::MONEY) AS order_encumbrance,
ROUND(CAST(sub.value AS NUMERIC (12,2))/100,2)::MONEY AS expenditure
FROM
sierra_view.fund_summary_subfund sub
JOIN
sierra_view.fund_summary fs
ON
sub.fund_summary_id = fs.id
JOIN
sierra_view.fund_property fp
ON
fs.fund_property_id = fp.id AND fp.fund_type_id = '1'
JOIN
sierra_view.fund_master fm
ON
fp.fund_master_id = fm.id
JOIN
sierra_view.fund_property_name fn
ON
fp.id = fn.fund_property_id
JOIN
sierra_view.accounting_unit a
ON
fm.accounting_unit_id = a.id AND a.code_num = {{accounting_unit}}
LEFT JOIN
order_encumbrance oe
ON
fm.code = oe.code AND sub.code = oe.subfund
ORDER BY 1,3