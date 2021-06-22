/*
Jeremy Goldstein
Minuteman Library Network

Gathers various stats around blocked patrons and amounts owed for use with analyzing fines
Takes a patron record fixed field as a variable to group on.
*/
WITH fine_data AS
(
SELECT
DISTINCT f.patron_record_id,
CASE WHEN f.charge_code IN ('3','5') THEN TRUE
ELSE FALSE
END AS is_lost
FROM
sierra_view.fine f
)

SELECT
{{grouping}},
/*
Possible values are
p3.name AS MA_town
pt.name AS ptype
l.name as home_library
*/
COUNT(DISTINCT p.id) as total_patrons,
COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100))) as total_blocked_patrons,
COUNT (DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100)) AND f.is_lost = true) AS total_lost_item_patrons,
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100))) as numeric (12,2)) / cast(COUNT(DISTINCT p.id) as numeric (12,2))),4) ||'%' AS pct_blocked,
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100))AND f.is_lost = true) as numeric (12,2)) / cast(COUNT(DISTINCT p.id) as numeric (12,2))),4) ||'%' AS pct_lost_item,
SUM(p.owed_amt)::MONEY AS total_owed,
SUM(p.owed_amt::MONEY) FILTER(WHERE ((p.mblock_code = '-') AND (p.owed_amt < 100))) AS total_owed_not_blocked,
SUM(p.owed_amt::MONEY) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100))) AS total_owed_blocked,
SUM(p.owed_amt::MONEY) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100)) AND f.is_lost = true) AS total_owed_lost_item,
AVG(p.owed_amt)::MONEY AS avg_owed,
(AVG(p.owed_amt) FILTER(WHERE ((p.mblock_code = '-') AND (p.owed_amt < 100))))::MONEY AS avg_owed_not_blocked,
(AVG(p.owed_amt) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100))))::MONEY AS avg_owed_blocked,
(AVG(p.owed_amt) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100)) AND f.is_lost = true))::MONEY AS avg_owed_lost_item,
MAX(p.owed_amt)::MONEY AS max_owed,
DATE_TRUNC('day', AVG(AGE(now()::date,p.activity_gmt::date)) FILTER(WHERE ((p.mblock_code = '-') OR (p.owed_amt < 100)))) AS avg_last_active_not_blocked,
DATE_TRUNC('day', AVG(AGE(now()::date,p.activity_gmt::date)) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100)))) AS avg_last_active_blocked
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
p.pcode3::varchar = p3.code::VARCHAR
JOIN
fine_data f
ON
p.id = f.patron_record_id
GROUP BY 1
ORDER BY 1;