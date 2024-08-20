/*
Jeremy Goldstein
Minuteman Library Network

Identifies instances where an item hold has a status of in transit
but the corresponding item does not
*/

SELECT
h.placed_gmt,
h.pickup_location_code,
h.is_frozen,
h.expires_gmt,
h.delay_days,
id2reckey(i.id)||'a' AS record_num,
i.item_status_code,
i.location_code,
s.name AS checkin_stat_group,
i.last_checkin_gmt

FROM
sierra_view.hold h
JOIN
sierra_view.item_record i
ON
h.record_id = i.id AND i.item_status_code != 't'
JOIN
sierra_view.statistic_group_myuser s
ON
i.checkin_statistics_group_code_num = s.code

WHERE
h.status = 't'


ORDER BY h.placed_gmt, s.name, i.last_checkin_gmt, i.location_code