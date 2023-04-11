/*
Jeremy Goldstein
Minuteman Library Network

Monthly turnover report for Woburn adult and teens materials
Requested by Suzanne Bouthillette
based on Youth Services report designed by Dorrie Karlin
*/

SELECT 
"Category Name",
"Total Owned",
"Total Circs",
ROUND(("Total Circs" * 1.00) / "Total Owned",2) AS Turnover
FROM(
SELECT
CASE
	WHEN i.icode1 IN ('127','129','131') THEN 'Audiobooks'
	WHEN i.icode1 IN ('92') THEN 'Biographies'
	WHEN i.icode1 IN ('148','149') THEN 'DVDs'
	WHEN i.icode1 = '147' THEN 'DVDs NF'
	WHEN i.icode1 IN ('6', '116', '117') THEN 'Large Print Fiction'
	WHEN i.icode1 = '103' THEN 'Large Print Non-fiction'
	WHEN i.icode1 IN ('145','159') THEN 'Video Games'
	WHEN i.icode1 IN ('167','169') THEN 'Graphic'
	WHEN i.icode1 IN ('153','160','161','164','165') THEN 'Teen Fiction'
	WHEN i.icode1 = '166' THEN 'Teen Non-fiction'
	WHEN i.icode1 = '0' THEN 'Bonnie No Scat'
	WHEN i.icode1 = '101' THEN 'Periodicals'
	WHEN i.icode1 IN ('126','143','158') THEN 'Adult LOT'
	WHEN i.icode1 = '138' THEN 'Equipment'
	WHEN i.icode1 IN ('1','2','3','5','9','108','109','110','111','115','123','133','134','248') THEN 'Fiction'
	WHEN (i.icode1 BETWEEN '10' AND '100') OR i.icode1 IN ('102','106','124','139') THEN 'Non-fiction'
END AS "Category Name",
COUNT(DISTINCT i.id) AS "Total Owned",
COUNT(DISTINCT C.id) AS "Total Circs"

FROM
sierra_view.item_record i
LEFT JOIN
sierra_view.circ_trans C
ON
i.id = C.item_record_id AND C.op_code IN ('o','r') AND C.transaction_gmt >= NOW()::DATE - INTERVAL '1 month'
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id

WHERE
i.location_code ~ '^wob'

GROUP BY 1) a
WHERE
"Category Name" IS NOT NULL

UNION

SELECT
'total' "AS Category NAME",
COUNT(DISTINCT i.id) AS "Total Owned",
COUNT(DISTINCT C.id) AS "Total Circs",
ROUND((COUNT(DISTINCT C.id) * 1.00) / COUNT(DISTINCT i.id),2) AS Turnover

FROM
sierra_view.item_record i
LEFT JOIN
sierra_view.circ_trans C
ON
i.id = C.item_record_id AND C.op_code IN ('o','r') AND C.transaction_gmt >= NOW()::DATE - INTERVAL '1 month'

WHERE
i.location_code ~ '^wob' 
AND (i.icode1  BETWEEN '10' AND '100'
 OR i.icode1 IN (
'127','129','131',
'92',
'148','149',
'147',
'6', '116', '117',
'103',
'145','159',
'167','169',
'153','160','161','164','165',
'166',
'0',
'101',
'126','143','158',
'138',
'1','2','3','5','9','108','109','110','111','115','123','133','134','248',
'102','106','124','139'
)
)

ORDER BY 1