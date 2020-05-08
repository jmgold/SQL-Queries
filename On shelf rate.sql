/*
Jeremy Goldstein
Minuteman Library Network
Captures number of items/titles of shelf vs checked out at this moment.
*/

SELECT
it.name AS itype,
COUNT(i.id) AS total_items,
COUNT(i.id) FILTER(WHERE C.id IS NULL) AS items_on_shelf,
COUNT(i.id) FILTER(WHERE C.id IS NOT NULL) AS items_checked_out,
ROUND(100.0 * (CAST(COUNT(i.id) FILTER(WHERE C.id IS NULL) AS NUMERIC (12,2)) / CAST(COUNT(i.id) AS NUMERIC (12,2))), 4)||'%' AS percentage_items_on_shelf,
COUNT(DISTINCT l.bib_record_id) AS total_tiles,
COUNT(DISTINCT l.bib_record_id) FILTER(WHERE C.id IS NULL) AS titles_on_shelf,
COUNT(DISTINCT l.bib_record_id) FILTER(WHERE C.id IS NOT NULL) AS titles_checked_out,
ROUND(100.0 * (CAST(COUNT(DISTINCT l.bib_record_id) FILTER(WHERE C.id IS NULL) AS NUMERIC (12,2)) / CAST(COUNT(DISTINCT l.bib_record_id) AS NUMERIC (12,2))), 4)||'%' AS percentage_titles_on_shelf

FROM
sierra_view.item_record i
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
LEFT JOIN
sierra_view.checkout C
ON
i.id = C.item_record_id

WHERE
i.location_code ~ '^ntn' AND i.item_status_code NOT IN ('r','e','o','q')

GROUP BY 1
ORDER BY 1