SELECT
*
FROM
(
SELECT
id2reckey(p.id)||'a' AS pnumber,
p.owed_amt,
SUM(f.item_charge_amt + f.billing_fee_amt + f.processing_fee_amt - f.paid_amt) AS fine_total

FROM
sierra_view.patron_record p
JOIN
sierra_view.fine f
ON
p.id = f.patron_record_id

GROUP BY 1,2) a

WHERE
a.owed_amt != a.fine_total
