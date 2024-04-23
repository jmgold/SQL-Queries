/*
Jeremy Goldstein
Minuteman Library Network

Report identifies all order records that are currently contributing to the encumbrance totals with a given accounting unit and order date range
*/

SELECT *,
'' AS "OPEN ORDERS",
'' AS "https://sic.minlib.net/reports/92"

FROM
(SELECT
rm.record_type_code||rm.record_num||'a' AS order_number,
b.best_title AS title,
o.order_date_gmt::DATE AS order_date,
o.order_status_code AS status,
f.fund_code,
fn.name AS fund,
o.vendor_record_code AS vendor,
cmf.copies,
o.estimated_price::MONEY AS eprice,
ROUND(SUM(o.estimated_price * (cmf.copies - COALESCE(op.copies,0))),2)::MONEY AS encumbered_amt

FROM
sierra_view.order_record o
JOIN
sierra_view.record_metadata rm
ON
o.id = rm.id
JOIN
sierra_view.bib_record_order_record_link l
ON
o.id = l.order_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
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
JOIN
sierra_view.fund f
ON
fm.code = f.fund_code AND f.fund_type = 'fbal'
JOIN
sierra_view.fund_property fp
ON
fm.id = fp.fund_master_id AND fp.fund_type_id = '1'
JOIN
sierra_view.fund_property_name fn
ON
fp.id = fn.fund_property_id
LEFT JOIN
sierra_view.order_record_paid op
ON
o.id = op.order_record_id AND o.order_status_code = 'q'

WHERE o.order_date_gmt::DATE < {{order_date}}
AND o.accounting_unit_code_num = {{accounting_unit}}
AND order_status_code IN ('o','q','g','d')
GROUP BY 1,2,3,4,5,6,7,8,9
ORDER BY 3,2
)a