SELECT
r.record_type_code||r.record_num||'a' AS pnumber,
COUNT(f.id) AS fine_count,
COALESCE(SUM(f.item_charge_amt + f.processing_fee_amt + f.billing_fee_amt)::MONEY, '0') AS total_fines,
COALESCE(SUM(f.item_charge_amt + f.processing_fee_amt + f.billing_fee_amt) FILTER(WHERE f.charge_code = '1'), '0')::MONEY AS total_manual_charge,
COALESCE(SUM(f.item_charge_amt + f.processing_fee_amt + f.billing_fee_amt) FILTER(WHERE f.charge_code = '2'), '0')::MONEY AS total_overdue,
COALESCE(SUM(f.item_charge_amt + f.processing_fee_amt + f.billing_fee_amt) FILTER(WHERE f.charge_code = '3'), '0')::MONEY AS total_replacement,
COALESCE(SUM(f.item_charge_amt + f.processing_fee_amt + f.billing_fee_amt) FILTER(WHERE f.charge_code = '4'), '0')::MONEY AS total_adjustment,
COALESCE(SUM(f.item_charge_amt + f.processing_fee_amt + f.billing_fee_amt) FILTER(WHERE f.charge_code = '5'), '0')::MONEY AS total_lost_book,
COALESCE(SUM(f.item_charge_amt + f.processing_fee_amt + f.billing_fee_amt) FILTER(WHERE f.charge_code = '6'), '0')::MONEY AS total_overdue_renewed,
COALESCE(SUM(f.item_charge_amt + f.processing_fee_amt + f.billing_fee_amt) FILTER(WHERE f.charge_code = '7'), '0')::MONEY AS total_rental,
COALESCE(SUM(f.item_charge_amt + f.processing_fee_amt + f.billing_fee_amt) FILTER(WHERE f.charge_code = '8'), '0')::MONEY AS total_rental_adjustment,
COALESCE(SUM(f.item_charge_amt + f.processing_fee_amt + f.billing_fee_amt) FILTER(WHERE f.charge_code = '9'), '0')::MONEY AS total_debit,
COALESCE(SUM(f.item_charge_amt + f.processing_fee_amt + f.billing_fee_amt) FILTER(WHERE f.charge_code = 'a'), '0')::MONEY AS total_notice,
COALESCE(SUM(f.item_charge_amt + f.processing_fee_amt + f.billing_fee_amt) FILTER(WHERE f.charge_code = 'b'), '0')::MONEY AS total_credit_card

FROM
sierra_view.fine f
JOIN
sierra_view.patron_record p
ON
f.patron_record_id = p.id AND p.ptype_code = '7'
JOIN
sierra_view.record_metadata r
ON
p.id = r.id
JOIN
sierra_view.item_record i
ON
f.item_record_metadata_id = i.id AND i.location_code ~ '^ca'

GROUP BY 1
ORDER BY 1