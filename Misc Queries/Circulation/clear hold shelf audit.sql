/*
Jeremy Goldstein
Minuteman Library Network

Looks for the item with the oldest holdshelf expiration date at each pickup location
to approximate the last time the holdshelf was cleared
*/

SELECT
h.pickup_location_code,
MIN(h.expire_holdshelf_gmt::DATE)


FROM
sierra_view.item_record i
JOIN
sierra_view.hold h
ON
i.id = h.record_id AND h.status IN ('b','i')
JOIN
sierra_view.record_metadata rm
ON
h.record_id = rm.id AND rm.campus_code = ''


WHERE
i.item_status_code = '!'
GROUP BY 1

ORDER BY 1,2