/*Jeremy Goldstein
  Minuteman Library Network
  Collection of stats by library related to patron blocks and circulation activity
*/

SELECT
f.loanrule_code_num,
COUNT(p.id) as total_patrons,
COUNT(p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) as total_block,
COUNT (p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10)) AND f.charge_code IN ('3','5')) AS total_block_lost_item,
CAST(COUNT(p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) as numeric (12,2)) / cast(COUNT(p.id) as numeric (12,2)) AS pct_block,
CAST(COUNT(p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))AND f.charge_code IN ('3','5')) as numeric (12,2)) / cast(COUNT(p.id) as numeric (12,2)) AS pct_block_lost_item,
DATE_TRUNC('day', AVG(AGE(now()::date,p.activity_gmt::date)) FILTER(WHERE ((p.mblock_code = '-') OR (p.owed_amt < 10)))) AS avg_last_active_not_blocked,
DATE_TRUNC('day', AVG(AGE(now()::date,p.activity_gmt::date)) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10)))) AS avg_last_active_blocked,
COUNT(p.id) FILTER(WHERE ((p.mblock_code = '-') OR (p.owed_amt < 10)) AND p.expiration_date_gmt < (now() + interval '1 year')) AS total_not_blocked_exp_this_year,
COUNT(p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10)) AND p.expiration_date_gmt < (now() + interval '1 year')) AS total_blocked_exp_this_year,
COUNT(p.id) FILTER(WHERE (((p.mblock_code != '-') OR (p.owed_amt >= 10)) AND f.charge_code IN ('3','5')) AND p.expiration_date_gmt < (now() + interval '1 year')) AS total_blocked_lost_item_exp_this_year,
AVG(f.item_charge_amt) as avg_item_charge,
SUM(f.item_charge_amt) as total_charged,
SUM(f.item_charge_amt) / COUNT(distinct p.id) as avg_charge_per_patron

FROM
sierra_view.patron_record p
LEFT JOIN
sierra_view.fine f
ON
p.id = f.patron_record_id
GROUP BY 1
ORDER BY 1;