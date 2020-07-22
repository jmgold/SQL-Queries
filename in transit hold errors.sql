SELECT
h.placed_gmt,
h.pickup_location_code,
h.is_frozen,
h.expires_gmt,
h.delay_days,
id2reckey(i.id)||'a' AS record_num,
i.item_status_code,
i.location_code

FROM
sierra_view.hold h
JOIN
sierra_view.item_record i
ON
h.record_id = i.id AND i.item_status_code != 't'
WHERE
h.status = 't'

ORDER BY i.location_code, h.placed_gmt