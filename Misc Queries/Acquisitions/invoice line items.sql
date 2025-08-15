/*
Jeremy Goldstein
Minuteman Library Network
Retrieves line items for each invoice paid during a set date range for an accounting unit
*/

SELECT
rm.record_type_code||rm.record_num||'a' AS record_number,
i.invoice_number_text AS invoice_number,
i.posted_data_gmt::DATE post_date,
fm.code AS fund_code,
fn.name AS fund_name,
l.title,
l.copies_paid_cnt AS qty,
/*
estimates shipping charge per line item assuming equal distribution among copies.
omits use of MONEY formatting in order to avoid rounding errors
Collaboration with Pam Skittino
*/
(i.discount_amt / (SUM(l.copies_paid_cnt) OVER (PARTITION BY rm.record_num)))*l.copies_paid_cnt AS est_shipping,
(l.paid_amt + (i.discount_amt / (SUM(l.copies_paid_cnt) OVER (PARTITION BY rm.record_num)))*l.copies_paid_cnt) AS paid_plus_shipping,
i.grand_total_amt::MONEY AS invoice_total,
i.paid_date_gmt::DATE AS paid_date
 
FROM
sierra_view.invoice_record i
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id
JOIN
sierra_view.accounting_unit a
ON
i.accounting_unit_code_num = a.code_num
JOIN
sierra_view.invoice_record_line l
ON
i.id = l.invoice_record_id
JOIN
sierra_view.fund_master fm
ON
l.fund_code::INTEGER = fm.code_num
AND fm.accounting_unit_id = a.id
JOIN
sierra_view.fund_property fp
ON
fm.id = fp.fund_master_id AND fp.fund_type_id = '1'
JOIN
sierra_view.fund_property_name fn
ON
fp.id = fn.fund_property_id

--set your date and accounting unit filters
WHERE
i.posted_data_gmt::DATE BETWEEN '2025-07-01' AND '2025-07-31'
AND a.code_num = '41'
 
ORDER BY fn.name,i.paid_date_gmt