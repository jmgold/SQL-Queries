SELECT
rm.record_last_updated_gmt::DATE,
rm.record_type_code||rm.record_num||'a' AS record_num,
id2reckey(h.patron_record_id)||'a' AS pnumber,
h.placed_gmt,
h.is_frozen,
h.delay_days,
h.expires_gmt,
h.status,
h.pickup_location_code

FROM
sierra_view.hold h
JOIN
sierra_view.record_metadata rm
ON
h.record_id = rm.id

WHERE 
h.status IN ('b','i')
AND rm.record_last_updated_gmt::DATE < NOW() - INTERVAL '2 months'
AND rm.campus_code = 'ncip'

ORDER BY 1