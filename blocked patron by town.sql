/*
Jeremy Goldstein
Minuteman Library Network

Provides overview of blocked and total patrons by each town
*/

SELECT
CASE
WHEN p3.code NOT IN ('1','3','4','7','9','19','21','27','28','29','30','35','36','37','43','47','50','51','61','62','63','64','69','75','76','79','83','95','98','102','103','113','114','115','116','119','120','124','126','129','130') THEN '_Non_MLN'
ELSE p3.name 
END AS library,
COUNT(DISTINCT p.id) as total_patrons,
COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10)) OR f.charge_code IN ('3','5')) as total_blocked_patrons,
COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10)) AND f.charge_code IN ('3','5')) AS total_lost_item_patrons,
COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE > NOW() - INTERVAL '1 year') AS total_active_last_year,
COUNT(DISTINCT p.id) FILTER(WHERE (((p.mblock_code != '-') OR (p.owed_amt >= 10)) OR f.charge_code IN ('3','5')) AND p.activity_gmt::DATE > NOW() - INTERVAL '1 year') AS total_blocked_active_last_year,
COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE BETWEEN NOW() - INTERVAL '2 years' AND NOW() - INTERVAL '1 year') AS "total_active_1-2_year",
COUNT(DISTINCT p.id) FILTER(WHERE (((p.mblock_code != '-') OR (p.owed_amt >= 10)) OR f.charge_code IN ('3','5')) AND p.activity_gmt::DATE BETWEEN NOW() - INTERVAL '2 years' AND NOW() - INTERVAL '1 year') AS "total_blocked_active_1-2_year",
COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE BETWEEN NOW() - INTERVAL '3 years' AND NOW() - INTERVAL '2 years') AS "total_active_2-3_year",
COUNT(DISTINCT p.id) FILTER(WHERE (((p.mblock_code != '-') OR (p.owed_amt >= 10)) OR f.charge_code IN ('3','5')) AND p.activity_gmt::DATE BETWEEN NOW() - INTERVAL '3 years' AND NOW() - INTERVAL '2 years') AS "total_blocked_active_2-3_year",
COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE BETWEEN NOW() - INTERVAL '4 years' AND NOW() - INTERVAL '3 years') AS "total_active_3-4_year",
COUNT(DISTINCT p.id) FILTER(WHERE (((p.mblock_code != '-') OR (p.owed_amt >= 10)) OR f.charge_code IN ('3','5')) AND p.activity_gmt::DATE BETWEEN NOW() - INTERVAL '4 years' AND NOW() - INTERVAL '3 years') AS "total_blocked_active_3-4_year",
COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE BETWEEN NOW() - INTERVAL '5 years' AND NOW() - INTERVAL '4 years') AS "total_active_4-5_year",
COUNT(DISTINCT p.id) FILTER(WHERE (((p.mblock_code != '-') OR (p.owed_amt >= 10)) OR f.charge_code IN ('3','5')) AND p.activity_gmt::DATE BETWEEN NOW() - INTERVAL '5 years' AND NOW() - INTERVAL '4 years') AS "total_blocked_active_4-5_year",
COUNT(DISTINCT p.id) FILTER(WHERE (p.activity_gmt::DATE < NOW() - INTERVAL '5 years')) AS "total_active_5+_years",
COUNT(DISTINCT p.id) FILTER(WHERE (((p.mblock_code != '-') OR (p.owed_amt >= 10)) OR f.charge_code IN ('3','5')) AND (p.activity_gmt::DATE < NOW() - INTERVAL '5 years')) AS "total_blocked_active_5+_years",
COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt IS NULL) AS no_activity
FROM
sierra_view.patron_record p
JOIN
sierra_view.location_myuser l
ON
REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REPLACE(REPLACE(REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REPLACE(SUBSTRING(p.home_library_code FOR 3),'ar2','arl'),'^br[23]','brk'),'^ca\d','cam'),'co2','con'),'dd2','ddm'),'fp2','fpl'),'^na\d','nat'),'^so\d','som'),'^we\d','wel'),'ww2','wwd') = SUBSTRING(l.code FOR 3) AND l.code ~ '^[a-z1-9]{3}$' AND l.code !~ '^mls'
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