WITH invoice_total AS (SELECT
i.id AS invoice_record_id,
fm.code AS fund_code,
COUNT(DISTINCT l.id) AS count_line_item,
SUM(l.paid_amt)::money AS subtotal,
copy_count.total_copies,
i.shipping_amt,
i.total_tax_amt,
(i.shipping_amt + i.total_tax_amt) / copy_count.total_copies AS added_fees,
SUM(l.paid_amt)::MONEY + (COUNT(DISTINCT l.id) * ((i.shipping_amt + i.total_tax_amt) / copy_count.total_copies))::MONEY AS total,
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
(SELECT
l.invoice_record_id,
SUM(l.copies_paid_cnt) AS total_copies
FROM
sierra_view.invoice_record_line l
GROUP BY 1)AS copy_count
ON
i.id = copy_count.invoice_record_id

--WHERE
--ID2RECKEY(i.id) = 'n3652917'

GROUP BY 1,2,5,6,7,8,10,11,12)

SELECT
fund_code,
SUM(subtotal) AS subtotal,
SUM(total) AS expenditure

FROM
invoice_total

WHERE
paid_date_gmt::DATE >= '2019-07-01'
AND 
code_num = '6'

GROUP BY 1
ORDER BY 1