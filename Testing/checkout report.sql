SELECT
--it.name AS itype,
--C.icode1::VARCHAR AS scat,
--UPPER(SUBSTRING(C.item_location_code,1,3)) AS owning_location,
--p3.name AS MA_town,
--pt.name AS ptype,
SG.name AS stat_group,
COUNT(C.id) FILTER(WHERE C.op_code = 'o') AS total_checkouts,
COUNT(C.id) FILTER(WHERE C.op_code = 'f') AS filled_holds,
ROUND(100.0 * CAST(COUNT(C.id) FILTER(WHERE C.op_code = 'f')AS NUMERIC (12,2)) / (COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_holds,
COUNT(C.id) FILTER(WHERE C.item_location_code ~ 'nat' AND C.op_code = 'o') AS local_items,
ROUND(100.0 * (CAST(COUNT(C.id) FILTER(WHERE C.item_location_code ~ 'nat'AND C.op_code = 'o')AS NUMERIC (12,2)) / COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_local,
COUNT(C.id) FILTER(WHERE C.item_location_code !~ 'nat'AND C.op_code = 'o') AS non_local_items,
ROUND(100.0 * (CAST(COUNT(C.id) FILTER(WHERE C.item_location_code !~ 'nat'AND C.op_code = 'o')AS NUMERIC (12,2)) / COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_non_local,
ROUND(100 * (CAST(COUNT(C.id) FILTER(WHERE C.op_code = 'o') AS NUMERIC (12,2)) / (SELECT CAST(COUNT (C.id) as numeric (12,2)) FROM sierra_view.circ_trans C WHERE C.stat_group_code_num BETWEEN '530' AND '539' AND C.op_code = 'o' AND C.transaction_gmt::DATE >= NOW()::DATE - INTERVAL '1 month')), 6)||'%' AS relative_checkout_total,
COUNT(DISTINCT C.patron_record_id) AS unique_patrons,
COALESCE(SUM(i.price) FILTER(WHERE C.op_code = 'o'),0)::MONEY AS total_value

FROM
sierra_view.circ_trans C
LEFT JOIN
sierra_view.item_record i
ON
C.item_record_id = i.id
JOIN
sierra_view.itype_property_myuser it
ON
C.itype_code_num = it.code
JOIN
sierra_view.user_defined_pcode3_myuser p3
ON
C.pcode3::VARCHAR = p3.code
JOIN
sierra_view.ptype_property_myuser pt
ON
C.ptype_code = pt.value::VARCHAR
JOIN
sierra_view.statistic_group_myuser sg
ON
C.stat_group_code_num = sg.code

WHERE 
C.stat_group_code_num BETWEEN '530' AND '539' 
AND C.op_code IN ('o','f')
AND C.transaction_gmt::DATE >= NOW()::DATE - INTERVAL '1 month'

GROUP BY 1

UNION

SELECT
'total' AS total,
COUNT(C.id) FILTER(WHERE C.op_code = 'o') AS total_checkouts,
COUNT(C.id) FILTER(WHERE C.op_code = 'f') AS filled_holds,
ROUND(100.0 * CAST(COUNT(C.id) FILTER(WHERE C.op_code = 'f')AS NUMERIC (12,2)) / (COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_holds,
COUNT(C.id) FILTER(WHERE C.item_location_code ~ 'nat' AND C.op_code = 'o') AS local_items,
ROUND(100.0 * (CAST(COUNT(C.id) FILTER(WHERE C.item_location_code ~ 'nat'AND C.op_code = 'o')AS NUMERIC (12,2)) / COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_local,
COUNT(C.id) FILTER(WHERE C.item_location_code !~ 'nat'AND C.op_code = 'o') AS non_local_items,
ROUND(100.0 * (CAST(COUNT(C.id) FILTER(WHERE C.item_location_code !~ 'nat'AND C.op_code = 'o')AS NUMERIC (12,2)) / COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_non_local,
ROUND(100 * (CAST(COUNT(C.id) FILTER(WHERE C.op_code = 'o') AS NUMERIC (12,2)) / (SELECT CAST(COUNT (C.id) as numeric (12,2)) FROM sierra_view.circ_trans C WHERE C.stat_group_code_num BETWEEN '530' AND '539' AND C.op_code = 'o' AND C.transaction_gmt::DATE >= NOW()::DATE - INTERVAL '1 month')), 6)||'%' AS relative_checkout_total,
COUNT(DISTINCT C.patron_record_id) AS unique_patrons,
COALESCE(SUM(i.price) FILTER(WHERE C.op_code = 'o'),0)::MONEY AS total_value

FROM
sierra_view.circ_trans C
LEFT JOIN
sierra_view.item_record i
ON
C.item_record_id = i.id
JOIN
sierra_view.itype_property_myuser it
ON
C.itype_code_num = it.code

WHERE 
C.stat_group_code_num BETWEEN '530' AND '539' 
AND C.op_code IN ('o','f')
AND C.transaction_gmt::DATE >= NOW()::DATE - INTERVAL '1 month'

ORDER BY 1