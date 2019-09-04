/*
aim for turnover >/< # of copies at different locations
currently duplicate counting checkouts
*/


SELECT
ID2RECKEY(b.bib_record_id)||'a',
b.best_title,
SUBSTRING(i.location_code,1,3),
COUNT(DISTINCT i.id) AS item_count,
COUNT(DISTINCT h.id) AS hold_count,
SUM(i.year_to_date_checkout_total) AS ytd_checkout,
SUM(i.last_year_to_date_checkout_total) AS last_ytd_checkout,
1.0 * SUM(i.year_to_date_checkout_total) + SUM(i.last_year_to_date_checkout_total) / COUNT(DISTINCT i.id) AS recent_turover,
MAX(i.last_checkout_gmt::DATE) AS last_out,
AVG(ROUND((CAST((i.checkout_total * 14) AS NUMERIC (12,2)) / (CURRENT_DATE - m.creation_date_gmt::DATE)),6)) AS avg_utilization


FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code ~ '^ca' AND i.item_status_code NOT IN ('z','e','o','r','n','m','w','$')
JOIN
sierra_view.record_metadata m
ON
i.id = m.id AND m.campus_code = '' AND m.creation_date_gmt::DATE != CURRENT_DATE
LEFT JOIN
sierra_view.hold h
ON
b.bib_record_id = h.record_id AND SUBSTRING(h.pickup_location_code,1,3) = SUBSTRING(i.location_code,1,3)
JOIN
sierra_view.bib_record_location bl
ON
b.bib_record_id = bl.bib_record_id

WHERE
b.material_code IN ('a','2')

GROUP BY 1,2,3
HAVING COUNT(bl.location_code) FILTER(WHERE bl.location_code ~ '^ca') > 1

ORDER BY 1