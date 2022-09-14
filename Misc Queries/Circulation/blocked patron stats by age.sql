/* 
Jeremy Goldstein
Minuteman Library Network
Gathers various stats around blocked patrons and amounts owed for use with analyzing fines
Grouped by patron age
*/

SELECT
DATE_TRUNC('year', AGE(CURRENT_DATE,p.birth_date_gmt)) AS age,
COUNT(p.id) AS total_patrons,
COUNT(p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100))) AS total_block,
COUNT (p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100)) AND f.charge_code IN ('3','5')) AS total_block_lost_item,
ROUND(100.0 * (CAST(COUNT(p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100))) AS NUMERIC (12,2)) / CAST(COUNT(p.id) AS NUMERIC (12,2))),4) ||'%' AS pct_block,
ROUND(100.0 * (CAST(COUNT(p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100)) AND f.charge_code IN ('3','5')) AS NUMERIC (12,2)) / CAST(COUNT(p.id) AS NUMERIC (12,2))),4) ||'%' AS pct_block_lost_item,
DATE_TRUNC('day', AVG(AGE(CURRENT_DATE,p.activity_gmt::DATE)) FILTER(WHERE ((p.mblock_code = '-') OR (p.owed_amt < 100)))) AS avg_last_active_not_blocked,
DATE_TRUNC('day', AVG(AGE(CURRENT_DATE,p.activity_gmt::DATE)) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100)))) AS avg_last_active_blocked,
COUNT(p.id) FILTER(WHERE ((p.mblock_code = '-') OR (p.owed_amt < 100)) AND p.expiration_date_gmt < (CURRENT_DATE + INTERVAL '1 year')) AS total_not_blocked_exp_this_year,
COUNT(p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100)) AND p.expiration_date_gmt < (CURRENT_DATE + INTERVAL '1 year')) AS total_blocked_exp_this_year,
COUNT(p.id) FILTER(WHERE (((p.mblock_code != '-') OR (p.owed_amt >= 100)) AND f.charge_code IN ('3','5')) AND p.expiration_date_gmt < (CURRENT_DATE + INTERVAL '1 year')) AS total_blocked_lost_item_exp_this_year

FROM
sierra_view.patron_record p

LEFT JOIN
sierra_view.fine f
ON
p.id = f.patron_record_id
GROUP BY 1
HAVING DATE_TRUNC('year', AGE(CURRENT_DATE,p.birth_date_gmt)) >= '1 YEAR' 
ORDER BY 1;