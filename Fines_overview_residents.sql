SELECT
l.name AS library,
COUNT(DISTINCT p.id) as total_patrons,
COUNT(DISTINCT p.id) FILTER(WHERE REPLACE(LOWER(l.name),'regis','regis college') = REPLACE(LOWER(p3.name),'fram.','framingham')) AS total_resident_patrons,
COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) as total_blocked_patrons,
COUNT(DISTINCT p.id) FILTER(WHERE REPLACE(LOWER(l.name),'regis','regis college') = REPLACE(LOWER(p3.name),'fram.','framingham') AND ((p.mblock_code != '-') OR (p.owed_amt >= 10))) AS total_blocked__resident_patrons,
COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10)) AND f.charge_code IN ('3','5')) AS total_lost_item_patrons,
COUNT(DISTINCT p.id) FILTER(WHERE REPLACE(LOWER(l.name),'regis','regis college') = REPLACE(LOWER(p3.name),'fram.','framingham') AND ((p.mblock_code != '-') OR (p.owed_amt >= 10)) AND f.charge_code IN ('3','5')) AS total_lost_item_resident_patrons,
COUNT(DISTINCT p.id) FILTER(WHERE REPLACE(LOWER(l.name),'regis','regis college') = REPLACE(LOWER(p3.name),'fram.','framingham') AND p.activity_gmt::DATE > NOW() - INTERVAL '1 year') AS total_resident_active_last_year,
COUNT(DISTINCT p.id) FILTER(WHERE REPLACE(LOWER(l.name),'regis','regis college') = REPLACE(LOWER(p3.name),'fram.','framingham') AND p.activity_gmt::DATE BETWEEN NOW() - INTERVAL '2 years' AND NOW() - INTERVAL '1 year') AS "total_resident_active_1-2_year",
COUNT(DISTINCT p.id) FILTER(WHERE REPLACE(LOWER(l.name),'regis','regis college') = REPLACE(LOWER(p3.name),'fram.','framingham') AND p.activity_gmt::DATE BETWEEN NOW() - INTERVAL '3 years' AND NOW() - INTERVAL '2 years') AS "total_resident_active_2-3_year",
COUNT(DISTINCT p.id) FILTER(WHERE REPLACE(LOWER(l.name),'regis','regis college') = REPLACE(LOWER(p3.name),'fram.','framingham') AND p.activity_gmt::DATE BETWEEN NOW() - INTERVAL '4 years' AND NOW() - INTERVAL '3 years') AS "total_resident_active_3-4_year",
COUNT(DISTINCT p.id) FILTER(WHERE REPLACE(LOWER(l.name),'regis','regis college') = REPLACE(LOWER(p3.name),'fram.','framingham') AND p.activity_gmt::DATE BETWEEN NOW() - INTERVAL '5 years' AND NOW() - INTERVAL '4 years') AS "total_resident_active_4-5_year",
COUNT(DISTINCT p.id) FILTER(WHERE REPLACE(LOWER(l.name),'regis','regis college') = REPLACE(LOWER(p3.name),'fram.','framingham') AND (p.activity_gmt::DATE < NOW() - INTERVAL '5 years' OR p.activity_gmt IS NULL)) AS "total_resident_active_5+_years"
/*ROUND(100.0 * (CAST(COUNT(p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) as numeric (12,2)) / cast(COUNT(p.id) as numeric (12,2))),4) ||'%' AS pct_blocked,
ROUND(100.0 * (CAST(COUNT(p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))AND f.charge_code IN ('3','5')) as numeric (12,2)) / cast(COUNT(p.id) as numeric (12,2))),4) ||'%' AS pct_lost_item,
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
*/
FROM
sierra_view.patron_record p
JOIN
sierra_view.location_myuser l
ON
REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REPLACE(REPLACE(REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REPLACE(SUBSTRING(p.home_library_code FOR 3),'ar2','arl'),'^br[23]','brk'),'^ca\d','cam'),'co2','con'),'dd2','ddm'),'fp2','fpl'),'^na\d','nat'),'^so\d','som'),'^we\d','wel'),'ww2','wwd') = SUBSTRING(l.code FOR 3) AND l.code ~ '^[a-z1-9]{3}$' AND l.code !~ '^mls'
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