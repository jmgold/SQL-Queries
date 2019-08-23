SELECT *,
a.total_missing + a.total_billed + a.total_claims_returned + a.total_lost_and_paid + a.total_no_checkouts_last_year AS total_problems
/*
Jeremy Goldstein
Minuteman Library Network

Identifies titles with the largest number of lost copies
*/


FROM
(
SELECT
id2reckey(b.bib_record_id)||'a' AS bib_number,
b.bib_record_id,
b.best_title AS title,
COUNT (i.id) AS total_copies,
COUNT (i.id) FILTER(WHERE i.item_status_code = 'm') AS total_missing,
COUNT (i.id) FILTER(WHERE i.item_status_code = 'n') AS total_billed,
COUNT (i.id) FILTER(WHERE i.item_status_code = 'z') AS total_claims_returned,
COUNT (i.id) FILTER(WHERE i.item_status_code = '$') AS total_lost_and_paid,
COUNT (i.id) FILTER(WHERE i.item_status_code NOT IN ('m','n','z','$','w','o','r','e','q') AND i.last_checkout_gmt < (NOW() - INTERVAL '1 year') AND m.creation_date_gmt < (NOW() - INTERVAL '1 year')) AS total_no_checkouts_last_year,
ROUND(1.0 * (SUM(i.last_year_to_date_checkout_total) + SUM(i.year_to_date_checkout_total))/COUNT(i.id),2) AS recent_network_wide_turnover

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
JOIN
sierra_view.record_metadata m
ON
i.id = m.id AND m.campus_code = ''
JOIN
sierra_view.bib_record br
ON
b.bib_record_id = br.id AND br.bcode3 NOT IN ('a','g','o','c','r','z','q','n')
LEFT JOIN
sierra_view.subfield v
ON
i.id = v.record_id AND v.field_type_code = 'v'

WHERE
b.material_code IN ('a')
GROUP BY 1,2,3
HAVING 
COUNT(v.*) = 0
AND (SUM(i.last_year_to_date_checkout_total) + SUM(i.year_to_date_checkout_total))/COUNT(i.id) > 3
)a

ORDER BY 9 DESC
LIMIT 100