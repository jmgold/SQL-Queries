SELECT
it.name AS itype,
COUNT(i.id) AS total_items,
COUNT(i.id) FILTER(WHERE C.id IS NULL) AS items_on_shelf,
COUNT(i.id) FILTER(WHERE C.id IS NOT NULL) AS items_checked_out,
ROUND(100.0 * (CAST(COUNT(i.id) FILTER(WHERE C.id IS NULL) AS NUMERIC (12,2)) / CAST(COUNT(i.id) AS NUMERIC (12,2))), 4)||'%' AS percentage_on_shelf

FROM
sierra_view.item_record i
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code
LEFT JOIN
sierra_view.checkout C
ON
i.id = C.item_record_id

WHERE
i.location_code ~ '^ntn'

GROUP BY 1
ORDER BY 1