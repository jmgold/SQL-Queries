/*
Jeremy Goldstein
Minuteman Library Network

Totals the outstanding fines for each checkout location
and breaks them out by charge type.
*/

SELECT
DISTINCT l.name AS checkout_location,
COALESCE(SUM(f.item_charge_amt + f.billing_fee_amt + f.processing_fee_amt - f.paid_amt) FILTER(WHERE f.charge_code = '1'),0)::MONEY AS total_manual_charge,
COALESCE(SUM(f.item_charge_amt + f.billing_fee_amt + f.processing_fee_amt - f.paid_amt) FILTER(WHERE f.charge_code = '2'),0)::MONEY AS total_overdue,
COALESCE(SUM(f.item_charge_amt + f.billing_fee_amt + f.processing_fee_amt - f.paid_amt) FILTER(WHERE f.charge_code = '3'),0)::MONEY AS total_replacement,
COALESCE(SUM(f.item_charge_amt + f.billing_fee_amt + f.processing_fee_amt - f.paid_amt) FILTER(WHERE f.charge_code = '4'),0)::MONEY AS total_adjustment,
COALESCE(SUM(f.item_charge_amt + f.billing_fee_amt + f.processing_fee_amt - f.paid_amt) FILTER(WHERE f.charge_code = '5'),0)::MONEY AS total_lost_book,
COALESCE(SUM(f.item_charge_amt + f.billing_fee_amt + f.processing_fee_amt - f.paid_amt) FILTER(WHERE f.charge_code = '6'),0)::MONEY AS total_overdue_renewed,
COALESCE(SUM(f.item_charge_amt + f.billing_fee_amt + f.processing_fee_amt - f.paid_amt) FILTER(WHERE f.charge_code = '7'),0)::MONEY AS total_rental,
COALESCE(SUM(f.item_charge_amt + f.billing_fee_amt + f.processing_fee_amt - f.paid_amt) FILTER(WHERE f.charge_code = '8'),0)::MONEY AS total_rental_adjustment,
SUM(f.item_charge_amt + f.billing_fee_amt + f.processing_fee_amt - f.paid_amt)::MONEY AS total


FROM
sierra_view.fine f
JOIN
sierra_view.location_myuser l
ON
SUBSTRING(f.charge_location_code,1,2) = SUBSTRING(l.code,1,2) AND l.code ~ '^[a-z]{3}$' AND l.code != 'mls'

WHERE SUBSTRING(f.charge_location_code,1,3) NOT IN ('','cmc','mb2','mbc','nby','non','trn','urs','zzz','mti')

GROUP BY 1
ORDER BY 1