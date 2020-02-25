SELECT
r.record_type_code||r.record_num||'a' AS pnumber,
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
COALESCE(SUM(f.item_charge_amt + f.processing_fee_amt + f.billing_fee_amt) FILTER(WHERE f.charge_code = 'b'), '0')::MONEY AS total_credit_card,
MIN(f.assessed_gmt::DATE) AS earliest_fine_date,
MAX(f.assessed_gmt::DATE) AS latest_fine_date,
PERCENTILE_DISC(.5) WITHIN GROUP (ORDER BY f.assessed_gmt::DATE) AS median_fine_date,
r.creation_date_gmt::DATE AS creation_date,
p.expiration_date_gmt::DATE AS expiration_date,
p.activity_gmt::DATE AS last_active_date

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

GROUP BY 1,17,18,19
ORDER BY 1
