SELECT 
id2reckey(l.bib_record_id)||'a'

FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code ~ '^fp3' AND i.item_status_code = '-' 

WHERE
h.pickup_location_code ~ '^fp[l|2]z' AND h.status = '0'