SELECT
SUBSTRING(p.home_library_code,1,3) AS home_library,
pt.name AS ptype,
COUNT(p.id) AS patron_total

FROM
sierra_view.patron_record p
JOIN
sierra_view.ptype_property_myuser pt
ON
p.ptype_code = pt.value

WHERE
p.home_library_code ~ '^br' AND p.ptype_code NOT IN ('6','106','306')
AND p.activity_gmt::DATE >= CURRENT_DATE - INTERVAL '1 year'

GROUP BY 1,2
ORDER BY 1,2