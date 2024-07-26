/*
Jeremy Goldstein
Minuteman Library Network

Retrieves invoices entered for credit memos
*/

SELECT
rm.record_type_code||rm.record_num||'a' AS record_number,
i.invoice_number_text AS invoice_number,
i.invoice_date_gmt::DATE AS invoice_date,
i.paid_date_gmt::DATE AS paid_date,
iv.vendor_code,
i.grand_total_amt,
il.note


FROM
sierra_view.invoice_record i
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id
JOIN
sierra_view.invoice_record_vendor_summary iv
ON
i.id = iv.invoice_record_id
JOIN
sierra_view.invoice_record_line il
ON
i.id = il.invoice_record_id

WHERE i.accounting_unit_code_num = '2' AND i.grand_total_amt < 0

ORDER BY 3,1