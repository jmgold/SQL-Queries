/*
Jeremy Goldstein
Minuteman Library Network

Looks for the oldest item on the hold shelf at each location to approximate the last time the holdshelf was cleared
*/

SELECT
h.pickup_location_code,
MIN(m.record_last_updated_gmt::DATE)
--m.record_last_updated_gmt::DATE,
--'i'||m.record_num||'a'

FROM
sierra_view.item_record i
JOIN
sierra_view.hold h
ON
i.id = h.record_id
JOIN
sierra_view.record_metadata m
ON
i.id = m.id AND m.campus_code = ''


WHERE
i.item_status_code = '!'
GROUP BY 1

ORDER BY 1,2