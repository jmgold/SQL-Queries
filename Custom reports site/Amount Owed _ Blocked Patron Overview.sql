/*
Jeremy Goldstein
Minuteman Library Network

Gathers various stats around blocked patrons and amounts owed for use with analyzing fines
Takes a patron record fixed field as a variable to group on.
*/

SELECT
{{grouping}},
COUNT(p.id) as total_patrons,
COUNT(p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) as total_blocked_patrons,
COUNT (p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10)) AND f.charge_code IN ('3','5')) AS total_lost_item_patrons,
ROUND(CAST(COUNT(p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) as numeric (12,2)) / cast(COUNT(p.id) as numeric (12,2)),6) AS pct_blocked,
ROUND(CAST(COUNT(p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))AND f.charge_code IN ('3','5')) as numeric (12,2)) / cast(COUNT(p.id) as numeric (12,2)),6) AS pct_lost_item,
SUM(p.owed_amt)::MONEY AS total_owed,
SUM(p.owed_amt::MONEY) FILTER(WHERE ((p.mblock_code = '-') AND (p.owed_amt < 10)) AND f.charge_code NOT IN ('3','5')) AS total_owed_not_blocked,
SUM(p.owed_amt::MONEY) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) AS total_owed_blocked,
SUM(p.owed_amt::MONEY) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10)) AND f.charge_code IN ('3','5')) AS total_owed_lost_item,
AVG(p.owed_amt)::MONEY AS avg_owed,
(AVG(p.owed_amt) FILTER(WHERE ((p.mblock_code = '-') AND (p.owed_amt < 10)) AND f.charge_code NOT IN ('3','5')))::MONEY AS avg_owed_not_blocked,
(AVG(p.owed_amt) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))))::MONEY AS avg_owed_blocked,
(AVG(p.owed_amt) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10)) AND f.charge_code IN ('3','5')))::MONEY AS avg_owed_lost_item,
MAX(p.owed_amt)::MONEY AS max_owed,
DATE_TRUNC('day', AVG(AGE(now()::date,p.activity_gmt::date)) FILTER(WHERE ((p.mblock_code = '-') OR (p.owed_amt < 10)))) AS avg_last_active_not_blocked,
DATE_TRUNC('day', AVG(AGE(now()::date,p.activity_gmt::date)) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10)))) AS avg_last_active_blocked
FROM
sierra_view.patron_record p
JOIN
sierra_view.location_myuser l
ON
SUBSTRING(p.home_library_code FOR 3) = SUBSTRING(l.code FOR 3) AND l.code ~ '^[a-z1-9]{3}$'
JOIN
sierra_view.ptype_property_myuser pt
ON
p.ptype_code = pt.value
JOIN
sierra_view.user_defined_pcode3_myuser p3
ON
p.pcode3::varchar = p3.code::varchar
LEFT JOIN
sierra_view.fine f
ON
p.id = f.patron_record_id
GROUP BY 1
ORDER BY 1;