WITH invoice_fund AS (SELECT
i.id AS invoice_record_id,
fm.code AS fund_code,
COUNT(DISTINCT l.id) AS count_line_item,
SUM(l.paid_amt)::money AS expenditure,
a.code_num,
SUM(l.copies_paid_cnt)

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


WHERE
ID2RECKEY(i.id) = 'n3652917'

GROUP BY 1,2,5)

SELECT
DISTINCT fi.fund_code,
--captures line items but not copies
fi.expenditure + ((i.shipping_amt::money + i.total_tax_amt::money) / copy_count.total_copies)
,fi.code_num,
copy_count.total_copies
FROM
invoice_fund fi
JOIN
sierra_view.invoice_record i
ON
fi.invoice_record_id = i.id
JOIN
sierra_view.invoice_record_line l
ON
i.id = l.invoice_record_id
JOIN
(SELECT
l.invoice_record_id,
SUM(l.copies_paid_cnt) AS total_copies
FROM
sierra_view.invoice_record_line l
GROUP BY 1)AS copy_count
ON
i.id = copy_count.invoice_record_id