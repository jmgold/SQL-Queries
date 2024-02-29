/*
Jeremy Goldstein
Minuteman Library Network

Compares current fund expenditures to the totals gathered from paid invoices
*/

--Gathers the expenditure break down for each fund within each invoice
WITH invoice_total AS (
SELECT
i.id AS invoice_record_id,
fm.code AS fund_code,
fm.id AS fm_id,
SUM(l.paid_amt) + (SUM(COALESCE(l.copies_paid_cnt,1)) * ((i.shipping_amt + i.total_tax_amt + i.discount_amt) / COALESCE(copy_count.total_copies,1))) AS total,
a.code_num

FROM
sierra_view.invoice_record i
JOIN
sierra_view.invoice_record_line l
ON
i.id = l.invoice_record_id
JOIN
sierra_view.accounting_unit a
ON
i.accounting_unit_code_num = a.code_num AND a.code_num = {{accounting_unit}}
JOIN
sierra_view.fund_master fm
ON
l.fund_code::INT = fm.code_num AND a.id = fm.accounting_unit_id
JOIN
sierra_view.fund f
ON
fm.code = f.fund_code AND f.fund_type = 'fbal' AND a.code_num = f.acct_unit
--Pull total number of items for each invoice
JOIN
(SELECT
l.invoice_record_id,
SUM(l.copies_paid_cnt) AS total_copies
FROM
sierra_view.invoice_record_line l
GROUP BY 1)AS copy_count
ON
i.id = copy_count.invoice_record_id

WHERE
--i.paid_date_gmt or i.invoice_date_gmt
{{date_field}}::DATE >= {{date_limit}}
/*
date_field options are
i.invoice_date_gmt
i.paid_date_gmt
*/
AND i.status_code = 'c'

GROUP BY 1,2,3,5,i.shipping_amt,i.total_tax_amt,i.discount_amt,copy_count.total_copies)

SELECT
*,
'' AS "FUND EXPENDITURE AUDIT",
'' AS "https://sic.minlib.net/reports/55"
FROM
(SELECT
it.fund_code,
fn.name,
ROUND(CAST(f.expenditure AS NUMERIC (12,2))/100,2)::MONEY AS expenditure,
COALESCE(SUM(it.total)::MONEY, 0.0::MONEY) AS invoice_expenditure,
ROUND(CAST(f.expenditure AS NUMERIC (12,2))/100,2)::MONEY - COALESCE(SUM(it.total)::MONEY, 0.0::MONEY) AS difference

FROM
sierra_view.fund f
JOIN
invoice_total it
ON
f.fund_code = it.fund_code AND f.acct_unit = it.code_num AND f.fund_type = 'fbal'
JOIN
sierra_view.accounting_unit a
ON
f.acct_unit = a.code_num
JOIN
sierra_view.fund_master fm
ON
f.fund_code = fm.code AND a.id = fm.accounting_unit_id
JOIN
sierra_view.fund_property fp
ON
fm.id = fp.fund_master_id AND fp.fund_type_id = '1'
JOIN
sierra_view.fund_property_name fn
ON
fp.id = fn.fund_property_id

GROUP BY 1,2,3

ORDER BY 1
)a