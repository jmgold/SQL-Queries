/*
Jeremy Goldstein
Minuteman Library Network

Identifies the most heavily utilized titles looking only at copies owned by a location

*/

SELECT
i.icode1 AS SCAT,
b.best_title AS title,
b.best_author AS author,
'b'||mb.record_num||'a' AS bib_num,
SUM(i.last_year_to_date_checkout_total) AS last_year_checkout_total,
MIN(m.creation_date_gmt::DATE) AS oldest_created_date,
ROUND(AVG(((CAST((i.last_year_to_date_checkout_total) AS NUMERIC (12,2)) / ('2019-06-30' - m.creation_date_gmt::DATE) * 365))),2) AS avg_ckout,
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
l.item_record_id = i.id AND i.location_code ~ '^ntn'
JOIN
sierra_view.record_metadata m
ON
i.id = m.id AND m.creation_date_gmt::DATE BETWEEN '2018-07-01' AND '2019-06-29'
JOIN
sierra_view.record_metadata mb
ON
b.bib_record_id = mb.id
JOIN
sierra_view.bib_record br
ON
b.bib_record_id = br.id AND br.bcode3 != 'e'
GROUP BY 1,2,3,4
ORDER BY 1, 7 DESC
