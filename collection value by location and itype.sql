SELECT
i.location_code,
l.name,
i.itype_code_num AS itype_code,
t.name AS itype_label,
sum(i.price) AS total_price
FROM
sierra_view.item_record i
JOIN
sierra_view.itype_property_myuser t
ON
i.itype_code_num = t.code
JOIN
sierra_view.location_myuser l
ON
i.location_code = l.code
WHERE
i.location_code like 'fp%'
GROUP BY 1,2,3,4
ORDER BY 1,3