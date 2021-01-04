SELECT
*

FROM
sierra_view.hold h
JOIN
sierra_view.record_metadata rm
ON
h.record_id = rm.id AND rm.record_type_code = 'b'
WHERE h.is_frozen = false AND h.pickup_location_code ~ '^ca'
AND h.status = '0'