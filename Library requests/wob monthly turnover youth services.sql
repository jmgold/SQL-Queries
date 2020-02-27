/*
Jeremy Goldstein
Minuteman Library Network
Monthly turnover report for Woburn childrens materials
*/

SELECT 
"Category Name",
"Total Owned",
"Total Circs",
ROUND(("Total Circs" * 1.00) / "Total Owned",2) AS Turnover
FROM(
SELECT
CASE
	WHEN i.icode1 IN ('173','50') THEN 'Audiobooks'
	WHEN i.icode1 IN ('233') THEN 'Big Books'
	WHEN i.icode1 IN ('220') THEN 'Biographies'
	WHEN i.icode1 IN ('200') THEN 'Board Books '
	WHEN i.icode1 IN ('236') THEN 'DVDs, fiction '
	WHEN i.icode1 IN ('235') THEN 'DVDs, nonfic'
	WHEN i.icode1 IN ('209', '194') THEN 'Early Readers ' 
	WHEN i.icode1 IN ('201', '202', '204', '205') THEN 'Fiction'
	WHEN i.icode1 IN ('190') THEN 'Graphic'
	WHEN i.icode1 IN ('207') THEN 'Holiday'
	WHEN i.icode1 IN ('138') THEN 'iPads'
	WHEN i.icode1 IN ('125') THEN 'Library of Things'
	WHEN i.icode1 IN ('192', '193', '195', '197') THEN 'Middle Readers'
	WHEN i.icode1 BETWEEN '210' AND '219' THEN 'Nonfiction'
	WHEN i.icode1 IN ('206', '196') THEN 'Picture Books'
	WHEN i.icode1 IN ('208') THEN 'PTR'
	WHEN i.icode1 IN ('199') THEN 'Readalongs'
	WHEN i.icode1 IN ('237', '238') THEN 'World'
END AS "Category Name",
COUNT(DISTINCT i.id) AS "Total Owned",
COUNT(DISTINCT C.id) AS "Total Circs"

FROM
sierra_view.item_record i
LEFT JOIN
sierra_view.circ_trans C
ON
i.id = C.item_record_id AND C.op_code IN ('o','r') AND C.transaction_gmt >= NOW()::DATE - INTERVAL '1 month'

WHERE
i.location_code ~ '^wob'

GROUP BY 1
ORDER BY 1) a
WHERE
"Category Name" IS NOT Null