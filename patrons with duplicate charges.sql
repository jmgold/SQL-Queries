--Original query created by Sarah Frieldsmith and shared on Sierra list 1/31/18
SELECT
id2reckey(f.patron_record_id)
FROM
sierra_view.fine f
WHERE
f.charge_code = '6'
GROUP BY
f.patron_record_id, date(f.assessed_gmt), f.item_record_metadata_id, f.item_charge_amt
HAVING
count(*) > 1