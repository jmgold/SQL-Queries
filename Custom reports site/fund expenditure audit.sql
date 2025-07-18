/*
Jeremy Goldstein
Minuteman Library Network

Compares current fund expenditures to the totals gathered from paid invoices
*/

--Gathers the expenditure break down for each fund within each invoice
WITH invoice_total AS (
SELECT
base.id AS invoice_record_id,
fm.code AS fund_code,
fm.id AS fm_id,
SUM(base.paid_amt) + (SUM(COALESCE(base.copies_paid_cnt,1)) * ((base.shipping_amt + base.total_tax_amt + base.discount_amt) / COALESCE(base.total_copies,1))) AS total,
a.code_num,
a.id AS accounting_unit_id

FROM (
    SELECT 
        i.*,
        l.fund_code,
        l.paid_amt,
        l.copies_paid_cnt,
        SUM(COALESCE(l.copies_paid_cnt,1)) OVER (PARTITION BY i.id) as total_copies
    FROM
        sierra_view.invoice_record i
        JOIN sierra_view.invoice_record_line l ON i.id = l.invoice_record_id
    WHERE
        --i.paid_date_gmt or i.invoice_date_gmt
        {{date_field}} >= {{date_limit}}::date
        AND i.status_code = 'c'
) base
JOIN
sierra_view.accounting_unit a
ON
base.accounting_unit_code_num = {{accounting_unit}} AND a.code_num = {{accounting_unit}}
JOIN
sierra_view.fund_master fm
ON
base.fund_code::INT = fm.code_num AND a.id = fm.accounting_unit_id
JOIN
sierra_view.fund f
ON
fm.code = f.fund_code AND f.fund_type = 'fbal' AND f.acct_unit = {{accounting_unit}}


GROUP BY base.id, fm.code, fm.id, a.code_num, a.id,
    base.shipping_amt, base.total_tax_amt, base.discount_amt, 
    base.total_copies)

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
f.fund_code = it.fund_code AND f.acct_unit = {{accounting_unit}} AND f.fund_type = 'fbal'
JOIN
sierra_view.fund_master fm
ON
f.fund_code = fm.code AND it.accounting_unit_id = fm.accounting_unit_id
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