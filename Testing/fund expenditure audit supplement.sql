WITH invoice_total AS (SELECT
i.id AS invoice_record_id,
fm.code AS fund_code,
fm.id AS fm_id,
copy_count.total_copies,
i.shipping_amt,
i.total_tax_amt,
i.discount_amt,
(i.shipping_amt + i.total_tax_amt + i.discount_amt) / copy_count.total_copies AS added_fees,
SUM(l.paid_amt)::MONEY + (SUM(l.copies_paid_cnt) * ((i.shipping_amt + i.total_tax_amt + i.discount_amt) / copy_count.total_copies))::MONEY AS total,
i.paid_date_gmt,
i.invoice_date_gmt,
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
i.accounting_unit_code_num = a.code_num
JOIN
sierra_view.fund_master fm
ON
l.fund_code::INT = fm.code_num AND a.id = fm.accounting_unit_id
JOIN
sierra_view.fund f
ON
fm.code = f.fund_code AND f.fund_type = 'fbal' AND a.code_num = f.acct_unit


JOIN
(SELECT
l.invoice_record_id,
SUM(l.copies_paid_cnt) AS total_copies
FROM
sierra_view.invoice_record_line l
GROUP BY 1)AS copy_count
ON
i.id = copy_count.invoice_record_id

--WHERE
--ID2RECKEY(i.id) = 'n1368579'

GROUP BY 1,2,3,4,5,6,7,8,10,11,12)

--Summing duplicate rows
SELECT
it.fund_code,
fn.name,
ROUND(CAST(f.expenditure AS NUMERIC (12,2))/100,2)::MONEY AS expenditure,
COALESCE(SUM(it.total)/3, 0.0::MONEY) AS invoice_expenditure,
ROUND(CAST(f.expenditure AS NUMERIC (12,2))/100,2)::MONEY - COALESCE(SUM(it.total)/3, 0.0::MONEY) AS difference

FROM
sierra_view.fund f
JOIN
invoice_total it
ON
f.fund_code = it.fund_code AND f.acct_unit = it.code_num AND f.fund_type = 'fbal' AND it.paid_date_gmt::DATE >= '2019-07-01'
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
fm.id = fp.fund_master_id
JOIN
sierra_view.fund_property_name fn
ON
fp.id = fn.fund_property_id

WHERE
f.acct_unit = '30'


GROUP BY 1,2,3

ORDER BY 1