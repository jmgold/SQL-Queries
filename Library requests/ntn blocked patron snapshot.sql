SELECT
f.patron_record_id,
SUM(f.item_charge_amt) FILTER(WHERE f.charge_code IN ('2','6'))::MONEY + SUM(f.billing_fee_amt) FILTER(WHERE f.charge_code = '4')::MONEY AS overdue_total,
SUM(f.item_charge_amt) FILTER(WHERE f.charge_code = '1')::MONEY AS manual_charge_total,
SUM(f.item_charge_amt) FILTER(WHERE f.charge_code IN ('3','5'))::MONEY AS replacement_total,
p.owed_amt::MONEY AS owed_amt
FROM
sierra_view.patron_record p
JOIN
sierra_view.fine f
ON
p.id = f.patron_record_id AND p.owed_amt >= 100 AND p.ptype_code = '29' --OR p.home_library_code = 'ntnz'

GROUP BY 1,5