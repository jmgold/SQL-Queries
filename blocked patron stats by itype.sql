SELECT
it.name as itype,
COUNT(distinct p.id) as total_patrons,
COUNT(distinct p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) as total_block,
cast(COUNT(distinct p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) as numeric (12,2)) / cast(COUNT(p.id) as numeric (12,2)) AS pct_blocked,
DATE_TRUNC('day', AVG(AGE(now()::date,p.activity_gmt::date)) FILTER(WHERE ((p.mblock_code = '-') OR (p.owed_amt < 10)))) AS avg_last_active_not_blocked,
DATE_TRUNC('day', AVG(AGE(now()::date,p.activity_gmt::date)) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10)))) AS avg_last_active_blocked,
COUNT(distinct p.id) FILTER(WHERE ((p.mblock_code = '-') OR (p.owed_amt < 10)) AND p.expiration_date_gmt < (now() + interval '1 year')) AS total_not_blocked_exp_this_year,
COUNT(distinct p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10)) AND p.expiration_date_gmt < (now() + interval '1 year')) AS total_blocked_exp_this_year,
AVG(f.item_charge_amt) as avg_item_charge,
SUM(f.item_charge_amt) as total_charged,
SUM(f.item_charge_amt) / COUNT(distinct p.id) as avg_charge_per_patron
FROM
sierra_view.fine f
JOIN
sierra_view.item_record i
ON f.item_record_metadata_id = i.id
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code
JOIN
sierra_view.patron_record p
ON
f.patron_record_id = p.id
GROUP BY 1
ORDER BY 1