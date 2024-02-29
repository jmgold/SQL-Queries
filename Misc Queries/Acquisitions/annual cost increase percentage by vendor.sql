/*
Jeremy Goldstein
Minuteman Library Network

Attempts to calculate the annual percentage increase for the costs associated with each vendor
looks at invoice line items.

*/
SELECT 
a.accounting_unit_code_num,
a.vendor_code,
a.year,
a.avg_price_per_copy::MONEY AS avg_price_per_copy,
ROUND(CASE
	WHEN LEAD(a.vendor_code,1) OVER (ORDER BY 1,2,3 DESC) != a.vendor_code THEN 0
	ELSE (a.avg_price_per_copy - (LEAD(a.avg_price_per_copy,1) OVER (ORDER BY 1,2,3 DESC))) / (LEAD(NULLIF(a.avg_price_per_copy,0),1) OVER (ORDER BY 1,2,3 DESC)) * 100
END,2) AS avg_price_per_copy_increase_pct,
a.total_paid::MONEY AS total_paid,
ROUND(CASE
	WHEN LEAD(a.vendor_code,1) OVER (ORDER BY 1,2,3 DESC) != a.vendor_code THEN 0
	ELSE (a.total_paid - (LEAD(a.total_paid,1) OVER (ORDER BY 1,2,3 DESC))) / (LEAD(NULLIF(a.total_paid,0),1) OVER (ORDER BY 1,2,3 DESC)) * 100
END,2) AS total_paid_increase_pct

FROM

(
SELECT
i.accounting_unit_code_num,
TRIM(l.vendor_code) AS vendor_code,
EXTRACT('year' FROM i.invoice_date_gmt) AS "year",
AVG(l.paid_amt / COALESCE(l.copies_paid_cnt,1)) AS avg_price_per_copy,
SUM(l.paid_amt) AS total_paid

FROM
sierra_view.invoice_record i
JOIN
sierra_view.invoice_record_line l
ON
i.id = l.invoice_record_id AND l.copies_paid_cnt != 0

GROUP BY 1,2,3
ORDER BY 1,2,3 DESC
)a

WHERE a.accounting_unit_code_num = '17'