SELECT
loc.name AS location,
COUNT(DISTINCT h.id) AS total_holds,
COUNT(DISTINCT h.id) - (COUNT(DISTINCT h.id) FILTER(WHERE SUBSTRING(i.location_code,1,3) = SUBSTRING(h.pickup_location_code,1,3) AND i.item_status_code IN ('-','p','u','!','t'))) AS no_local_items

FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.bib_record_id OR h.record_id = l.item_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
JOIN
sierra_view.location_myuser loc
ON
SUBSTRING(h.pickup_location_code,1,3) = loc.code

WHERE h.status = '0' AND h.is_frozen = 'FALSE'

GROUP BY 1
ORDER BY 1