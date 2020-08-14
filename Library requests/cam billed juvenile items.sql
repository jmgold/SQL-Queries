SELECT
SUM(f.item_charge_amt+f.billing_fee_amt+f.processing_fee_amt)::MONEY,
COUNT(f.id),
COUNT(DISTINCT f.item_record_metadata_id)
FROM
sierra_view.fine f
JOIN
sierra_view.item_record i
ON
f.item_record_metadata_id = i.id AND i.location_code ~ '^ca[m3-9]j'
JOIN
sierra_view.patron_record p
ON
f.patron_record_id = p.id AND p.ptype_code = '7'
WHERE
f.charge_code IN ('3','5')