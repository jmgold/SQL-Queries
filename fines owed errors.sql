/*
query originally shared by Bob Gaydos over Idea Lab
*/

SET search_path = 'sierra_view';
SELECT
    'p' || rm.record_num || 'a' AS Patron_ID,
    p.owed_amt::MONEY AS owed_amt,
    SUM(COALESCE(f.item_charge_amt, 0.00) + COALESCE(f.processing_fee_amt, 0.00) + COALESCE(f.billing_fee_amt, 0.00) - COALESCE(f.paid_amt, 0.00))::MONEY AS TotalFines
FROM record_metadata rm
INNER JOIN patron_record p
   ON p.id = rm.id
LEFT OUTER JOIN fine f
   ON f.patron_record_id = p.id
GROUP BY
    rm.record_num,
    p.owed_amt
HAVING p.owed_amt != SUM(COALESCE(f.item_charge_amt, 0.00) + COALESCE(f.processing_fee_amt, 0.00) + COALESCE(f.billing_fee_amt, 0.00) - COALESCE(f.paid_amt, 0.00))
;