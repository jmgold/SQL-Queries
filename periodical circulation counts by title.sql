/*
Jeremy Goldstein
Minuteman Library Network

Gathers ytd and total circ counts for each periodical title at a location
*/
SELECT
b.best_title,
SUM(i.year_to_date_checkout_total) AS year_to_date_total_checkouts,
SUM(i.checkout_total) AS total_checkouts,
COUNT(i.id) AS num_issues
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code LIKE 'wob%'
WHERE
b.material_code = '3'
GROUP BY 1
ORDER BY 1