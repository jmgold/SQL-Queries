SELECT
i.location_code AS location,
it.code AS itype_code,
it.name AS itype,
i.icode1 AS scat,
COUNT(i.id) AS total

FROM
sierra_view.item_record i
RIGHT JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code

WHERE i.location_code ~ '^wwd'
GROUP BY 1,2,3,4
HAVING it.name != ''

ORDER BY 1,2,4