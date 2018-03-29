SELECT f.fine_assessed_date_gmt,
f.item_charge_amt,
f.charge_type_code,
f.paid_date_gmt,
f.loan_rule_code_num,
f.paid_now_amt,
i.icode1,
i.itype_code_num,
i.location_code 
FROM sierra_view.fines_paid f
JOIN
sierra_view.record_metadata m
ON
f.item_record_metadata_id = m.id AND m.deletion_date_gmt IS NULL
JOIN
sierra_view.item_view i
ON
m.record_num = i.record_num 
WHERE i.location_code LIKE 'ntn%'
ORDER BY 4