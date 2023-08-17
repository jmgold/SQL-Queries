/*
Jeremy Goldstein
Minuteman Library Network

Identifies patron records where the current owed_amt does not equal their outstanding fines
*/

SELECT
*
FROM
(
SELECT
rm.record_type_code||rm.record_num||'a' AS pnumber,
p.owed_amt::MONEY AS owed_amt,
SUM(f.item_charge_amt + f.billing_fee_amt + f.processing_fee_amt - f.paid_amt)::MONEY AS fine_total,
p.owed_amt::MONEY - SUM(f.item_charge_amt + f.billing_fee_amt + f.processing_fee_amt - f.paid_amt)::MONEY AS difference

FROM
sierra_view.patron_record p
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id
JOIN
sierra_view.fine f
ON
p.id = f.patron_record_id

GROUP BY 1,2) a

WHERE
a.owed_amt != a.fine_total
