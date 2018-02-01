--Original query created by Sarah Frieldsmith and shared on Sierra list 1/31/18
SELECT
id2reckey(f.patron_record_id),
date(f.assessed_gmt),
p.activity_gmt,
p.owed_amt
FROM
sierra_view.fine f
JOIN
sierra_view.patron_record p
ON
f.patron_record_id = p.id
WHERE
f.charge_code = '6'
GROUP BY
f.patron_record_id, date(f.assessed_gmt), f.item_record_metadata_id, f.item_charge_amt, p.activity_gmt,p.owed_amt
HAVING
count(*) > 1
order by 1,3