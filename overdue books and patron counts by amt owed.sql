SELECT
l.name AS home_library,
COUNT(DISTINCT p.id) as total_patrons,
COUNT(DISTINCT p.id) FILTER(WHERE p.owed_amt >= 100) as total_patrons_owe_100,
COUNT(DISTINCT o.item_record_id) FILTER(WHERE p.owed_amt >= 100) AS total_overdue_items_owe_100,
COUNT(DISTINCT p.id) FILTER(WHERE p.owed_amt >= 75) as total_patrons_owe_75,
COUNT(DISTINCT o.item_record_id) FILTER(WHERE p.owed_amt >= 75) AS total_overdue_items_owe_75,
COUNT(DISTINCT p.id) FILTER(WHERE p.owed_amt >= 50) as total_patrons_owe_50,
COUNT(DISTINCT o.item_record_id) FILTER(WHERE p.owed_amt >= 50) AS total_overdue_items_owe_50,
COUNT(DISTINCT p.id) FILTER(WHERE p.owed_amt >= 25) as total_patrons_owe_25,
COUNT(DISTINCT o.item_record_id) FILTER(WHERE p.owed_amt >= 25) AS total_overdue_items_owe_25,
COUNT(DISTINCT p.id) FILTER(WHERE p.owed_amt >= 10) as total_patrons_owe_10,
COUNT(DISTINCT o.item_record_id) FILTER(WHERE p.owed_amt >= 10) AS total_overdue_items_owe_10
/*ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE p.owed_amt >= 100) as numeric (12,2)) / cast(COUNT(DISTINCT p.id) as numeric (12,2))),4) ||'%' AS pct_owe_100,
SUM(p.owed_amt)::MONEY AS total_owed,
SUM(p.owed_amt::MONEY) FILTER(WHERE ((p.mblock_code = '-') AND (p.owed_amt < 100))) AS total_owed_not_blocked,
SUM(p.owed_amt::MONEY) FILTER(WHERE p.owed_amt >= 100) AS total_owed_owe_100,
AVG(p.owed_amt)::MONEY AS avg_owed,
(AVG(p.owed_amt) FILTER(WHERE ((p.mblock_code = '-') AND (p.owed_amt < 100))))::MONEY AS avg_owed_not_blocked,
(AVG(p.owed_amt) FILTER(WHERE p.owed_amt >= 100))::MONEY AS avg_owed_owe_100,
MAX(p.owed_amt)::MONEY AS max_owed*/
FROM

sierra_view.patron_record p
JOIN
sierra_view.location_myuser l
ON
SUBSTRING(p.home_library_code FOR 3) = SUBSTRING(l.code FOR 3) AND l.code ~ '^[a-z1-9]{3}$'
LEFT JOIN
sierra_view.checkout o
ON
p.id = o.patron_record_id AND o.due_gmt::DATE < CURRENT_DATE
GROUP BY 1
ORDER BY 1;