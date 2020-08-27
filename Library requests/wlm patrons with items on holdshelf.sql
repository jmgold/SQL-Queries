SELECT
DISTINCT s.content
FROM
sierra_view.hold h
JOIN
sierra_view.subfield s
ON
h.patron_record_id = s.record_id AND s.field_type_code = 'z' AND s.occ_num = 0

WHERE h.pickup_location_code = 'ntnz'
AND h.status IN ('b','i')