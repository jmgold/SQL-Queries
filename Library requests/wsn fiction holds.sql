SELECT
rm.record_type_code||rm.record_num||'a' AS record_number,
b.best_title AS title,
COUNT(h.id) AS total_holds,
COUNT(h.id) FILTER(WHERE h.pickup_location_code = 'wsnz') AS local_holds,
rm.creation_date_gmt::DATE AS created_date
FROM
sierra_view.item_record i
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.hold h
ON l.bib_record_id = h.record_id OR l.item_record_id = h.record_id
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id

WHERE
i.icode1 IN ('1', '2','3', '4', '5' ,'8', '9', '115', '119', '116', '117')
AND i.location_code ~ '^wsn'

GROUP BY 1,2,5
HAVING COUNT(h.id) > 0

ORDER BY 4 desc