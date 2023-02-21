/*
Jeremy Goldstein
Minuteman Library Network

Identifies rows of the fines table that represent fines on items that have been deleted
*/

SELECT
f.id,
id2reckey(f.patron_record_id)||'a' AS pnumber,
f.assessed_gmt,
f.invoice_num,
f.item_charge_amt::MONEY AS item_charge_amt,
f.processing_fee_amt::MONEY AS processing_fee_amt,
f.billing_fee_amt::MONEY AS billing_fee_amt,
f.charge_code,
f.charge_location_code,
f.paid_gmt,
f.terminal_num,
rm.record_type_code||rm.record_num||'a' AS inumber,
f.checkout_gmt,
f.due_gmt::DATE AS due_date,
f.returned_gmt,
f.loanrule_code_num,
f.title

FROM
sierra_view.fine f
JOIN
sierra_view.record_metadata rm
ON
f.item_record_metadata_id = rm.id AND rm.deletion_date_gmt IS NOT NULL