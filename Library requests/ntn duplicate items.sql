/*
Jeremy Goldstein
Minuteman Library Network

use to gather bibs where a library owns multiple circulating copies of a title.
and recent circ suggests that some copies could be weeded

Passed variables for owning location, item statuses to exclude, copies greater than x and turnover less than y
*/

SELECT 
id2reckey(b.bib_record_id)||'a' AS bib_number,
b.best_title AS title,
b.best_author AS author,
STRING_AGG(DISTINCT ip.call_number_norm, ', ') AS call_number,
mat.name AS mattype,
count(i.id) AS item_count,
sum(i.last_year_to_date_checkout_total) AS last_ytd_checkouts,
SUM(i.year_to_date_checkout_total) AS ytd_checkouts,
ROUND((SUM(i.year_to_date_checkout_total) + sum(i.last_year_to_date_checkout_total))::NUMERIC/count(i.id),2) AS turnover

FROM 
sierra_view.bib_record_property AS b
JOIN
sierra_view.bib_record bib
ON
b.bib_record_id = bib.id
AND bib.bcode1 = 'm'
JOIN
sierra_view.bib_record_item_record_link AS l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record as i
ON
i.id = l.item_record_id
--AND i.item_status_code NOT IN ({{Item_Status_Codes}}) 
AND i.location_code ~ '^ntn'
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.material_property_myuser mat
ON
b.material_code = mat.code


/*WHERE
b.material_code IN {{mat_type}}*/
GROUP BY 1, 2, 3, 5
HAVING COUNT(i.id) > 1
--AND (SUM(i.year_to_date_checkout_total) + sum(i.last_year_to_date_checkout_total))::NUMERIC/count(i.id) < {{Turnover}}
ORDER BY 5,2
;