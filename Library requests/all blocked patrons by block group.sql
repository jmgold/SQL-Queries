/*
Jeremy Goldstein
Minuteman Library Network

Gathers various patron record statistics grouped on a choice of geography
Census block geoids are stored in patron census fields and can be used to
join results to census data
*/

SELECT
pc.name AS matown,
COUNT(DISTINCT p.id) AS total_patrons,
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100))) AS NUMERIC (12,2)) / CAST(COUNT(DISTINCT p.id) AS NUMERIC (12,2))),4) ||'%' AS pct_blocked_100,
COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100))) as total_blocked_patrons_100,
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 50))) AS NUMERIC (12,2)) / CAST(COUNT(DISTINCT p.id) AS NUMERIC (12,2))),4) ||'%' AS pct_blocked_50,
COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 50))) as total_blocked_patrons_50,
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) AS NUMERIC (12,2)) / CAST(COUNT(DISTINCT p.id) AS NUMERIC (12,2))),4) ||'%' AS pct_blocked_10,
COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) as total_blocked_patrons_10,
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt BETWEEN 11 AND 99.99))) AS NUMERIC (12,2)) / CAST(COUNT(DISTINCT p.id) AS NUMERIC (12,2))),4) ||'%' AS pct_blocked_between,
COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt BETWEEN 11 AND 99.99))) as total_blocked_patrons_beween

FROM
sierra_view.patron_record p
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id
AND a.patron_record_address_type_id = '1'
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id
--for census field
JOIN
sierra_view.user_defined_pcode3_myuser pc
ON
p.pcode3::varchar = pc.code



--WHERE SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ({{tracts}})
--p.ptype_code IN ({{ptype}})

GROUP BY 1
ORDER BY 1