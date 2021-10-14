SELECT
rm.record_type_code||rm.record_num||'a' AS bib_number,
b.best_title AS title,
b.best_author AS author,
b.publish_year,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^dea') AS local_copies,
COUNT(i.id) FILTER(WHERE i.location_code !~ '^dea') AS non_local_copies,
MAX(i.last_checkout_gmt::DATE) FILTER(WHERE i.location_code ~ '^dea') AS last_checkout_dea,
MAX(i.last_checkout_gmt::DATE) AS last_checkout_network,
SUM(i.checkout_total) AS checkout_total

FROM
sierra_view.bib_record_location bl
JOIN
sierra_view.bib_record_item_record_link l
ON
bl.bib_record_id = l.bib_record_id AND bl.location_code = 'multi'
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
JOIN
sierra_view.record_metadata rm
ON
l.bib_record_id = rm.id
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
LEFT JOIN
sierra_view.varfield v
ON
i.id = v.record_id AND v.varfield_type_code = 'r'

GROUP BY 1,2,3,4
HAVING COUNT(i.id) FILTER(WHERE i.location_code ~ '^dea') > 0
AND COUNT(i.id) FILTER(WHERE i.location_code !~ '^dea') > 0 
AND COUNT(i.id) FILTER(WHERE i.location_code ~ '^dea' AND v.field_content IS NOT NULL) = 0
ORDER BY 6 DESC