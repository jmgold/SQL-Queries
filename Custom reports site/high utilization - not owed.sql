/*
Jeremy Goldstein
Minuteman Library Network

Identifies the most heavily utilized titles not owned at a location

*/

SELECT
b.best_title AS title,
b.best_author AS author,
'b'||mb.record_num||'a' AS bib_number,
AVG(i.checkout_total) AS avg_checkout_total,
AVG(CURRENT_DATE - m.creation_date_gmt::DATE) AS avg_age,
AVG(ROUND((CAST((i.checkout_total * 14) AS NUMERIC (12,2)) / (CASE WHEN CURRENT_DATE - m.creation_date_gmt::DATE = 0 THEN 1 ELSE CURRENT_DATE - m.creation_date_gmt::DATE END)),6)) AS avg_utilization,
COUNT(l.id) AS item_total,
MAX(i.last_checkout_gmt::DATE) AS last_checkout_date

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id 

JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.item_status_code NOT IN ({{item_status_codes}})
JOIN
sierra_view.record_metadata m
ON
i.id = m.id AND m.creation_date_gmt::DATE < {{created_date}}
JOIN
sierra_view.record_metadata mb
ON
b.bib_record_id = mb.id
JOIN
sierra_view.bib_record br
ON
b.bib_record_id = br.id AND br.bcode3 != 'e'
WHERE
b.material_code IN ({{mat_type}})
GROUP BY 1,2,3
HAVING
COUNT(i.id) FILTER (WHERE i.location_code ~ {{location}}) = 0
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
ORDER BY 6 DESC,1
LIMIT {{qty}}