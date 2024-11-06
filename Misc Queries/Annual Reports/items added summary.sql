/*
Jeremy Goldstein
Minuteman Library Network

Items Added Summary used for annual reports
*/

SELECT
CASE
WHEN SUBSTRING(i.location_code, 1, 2) = 'ac' THEN 'ACTON'
WHEN SUBSTRING(i.location_code, 1, 2) = 'ar' THEN 'ARLINGTON'
WHEN SUBSTRING(i.location_code, 1, 2) = 'br' THEN 'BROOKLINE'
WHEN SUBSTRING(i.location_code, 1, 2) = 'ca' THEN 'CAMBRIDGE'
WHEN SUBSTRING(i.location_code, 1, 2) = 'co' THEN 'CONCORD'
WHEN SUBSTRING(i.location_code, 1, 2) = 'dd' THEN 'DEDHAM'
WHEN SUBSTRING(i.location_code, 1, 2) = 'fp' THEN 'FRAMINGHAM'
WHEN SUBSTRING(i.location_code, 1, 2) = 'na' THEN 'NATICK'
WHEN SUBSTRING(i.location_code, 1, 2) = 'so' THEN 'SOMERVILLE'
WHEN SUBSTRING(i.location_code, 1, 2) = 'wl' THEN 'WALTHAM'
WHEN SUBSTRING(i.location_code, 1, 2) = 'wa' THEN 'WATERTOWN'
WHEN SUBSTRING(i.location_code, 1, 2) = 'we' THEN 'WELLESLEY'
WHEN SUBSTRING(i.location_code, 1, 2) = 'ww' THEN 'WESTWOOD'
ELSE l.NAME 
END AS Library,
COUNT(i.id) AS "ITEM RECORDS ADDED",
COUNT(i.id) FILTER(WHERE i.itype_code_num NOT IN ('10','107', '158', '239', '240', '241', '242', '244', '248', '249')) AS "ADJUSTED TOTAL"
FROM
sierra_view.item_record i
JOIN
sierra_view.location_myuser l
ON
SUBSTRING(i.location_code, 1, 3) = l.code AND i.itype_code_num != '80'
JOIN
sierra_view.record_metadata m
ON
i.id = m.id AND m.creation_date_gmt >= NOW() - INTERVAL '1 year'
GROUP BY 1
ORDER BY 1
