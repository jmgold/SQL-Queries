/*
Jeremy Goldstein
Minuteman Library Network

Identifies titles where a library has copies in multiple locations
and provides comparative circ stats for items within each location
*/

WITH multi_location AS(
SELECT

b.best_title||b.best_author AS title,
--b.bib_record_id,
COUNT(DISTINCT i.location_code) AS instance_count

FROM
sierra_view.bib_record_property b

JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code ~ '{{location}}' AND i.item_status_code NOT IN ({{item_status_codes}})
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.

WHERE
b.material_code IN ({{mat_type}})
GROUP BY 1
HAVING COUNT(DISTINCT i.location_code) > 1
)

SELECT
--id2reckey(b.bib_record_id)||'a' AS bib_num,
b.best_title AS title,
STRING_AGG(DISTINCT id2reckey(b.bib_record_id)||'a',', ') AS bib_numbers,
loc.name AS location,
SUM(i.checkout_total) AS checkout_total,
SUM(i.renewal_total) AS renewal_total,
COUNT(i.id) AS item_total,
round(cast(SUM(i.checkout_total) + SUM(i.renewal_total) as numeric (12,2))/cast(COUNT (i.id) as numeric (12,2)), 2) as turnover,
SUM(i.year_to_date_checkout_total) AS year_to_date_checkout_total,
SUM(i.last_year_to_date_checkout_total) AS last_year_to_date_checkout_total,
AVG(ROUND((CAST(((i.checkout_total + i.renewal_total) * 14) AS NUMERIC (12,2)) / (CURRENT_DATE - rm.creation_date_gmt::DATE)),6)) FILTER (WHERE rm.creation_date_gmt::DATE != CURRENT_DATE) AS avg_utilization,
MIN(rm.creation_date_gmt::DATE) AS first_created_date,
MAX(i.last_checkout_gmt::DATE) AS last_out_date
FROM
multi_location M
JOIN
sierra_view.bib_record_property b
ON
M.title = b.best_title||best_author
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code ~ '{{location}}' AND i.item_status_code NOT IN ({{item_status_codes}})
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id
JOIN
sierra_view.location_myuser loc
ON
i.location_code = loc.code

GROUP BY 1,3