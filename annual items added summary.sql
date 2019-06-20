/*
Jeremy Goldstein
Minuteman Library Network

Items Added Summary used for annual reports
*/

SELECT
CASE
WHEN l.name LIKE 'ARLINGTON%' THEN 'ARLINGTON'
WHEN l.name LIKE 'BROOKLINE%' THEN 'BROOKLINE'
WHEN l.name LIKE 'CAMBRIDGE%' THEN 'CAMBRIDGE'
WHEN l.name LIKE 'CONCORD%' THEN 'CONCORD'
WHEN l.name LIKE 'DEDHAM%' THEN 'DEDHAM'
WHEN l.name LIKE 'FRAMINGHAM%' THEN 'FRAMINGHAM'
WHEN l.name LIKE 'NATICK%' THEN 'NATICK'
WHEN l.name LIKE 'SOMERVILLE%' THEN 'SOMERVILLE'
WHEN l.name LIKE 'WELLESLEY%' THEN 'WELLESLEY'
WHEN l.name LIKE 'WESTWOOD%' THEN 'WESTWOOD'
ELSE l.NAME 
END AS Library,
COUNT(i.id) AS "ITEM RECORDS ADDED",
COUNT(i.id) FILTER(WHERE i.itype_code_num NOT IN ('10','107', '158', '239', '240', '241', '242', '244', '248', '249')) AS "ADJUSTED TOTAL"
FROM
sierra_view.item_record i
JOIN
sierra_view.location_myuser l
ON
SUBSTRING(i.location_code, 1, 3) = l.code
JOIN
sierra_view.record_metadata m
ON
i.id = m.id AND m.creation_date_gmt >= NOW() - INTERVAL '1 year'
GROUP BY 1
ORDER BY 1