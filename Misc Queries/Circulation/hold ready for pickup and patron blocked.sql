/*
Query from Ray Voelker

Identifies holds with a ready for pickup status where the patron is currently blocked due to a manual block or fine limit
*/

DROP TABLE IF EXISTS temp_ready_for_pickup
;
CREATE TEMP TABLE temp_ready_for_pickup as
SELECT
h.patron_record_id,
h.record_id,
h.pickup_location_code
FROM
sierra_view.hold as h
WHERE
h.status IN ('b','i')
;
CREATE INDEX IF NOT EXISTS temp_idx_patron_item_read_for_pickup ON temp_ready_for_pickup ( patron_record_id )
;
SELECT
p.record_id as patron_record_id,
p.home_library_code,
p.owed_amt,
t.record_id,
t.pickup_location_code

FROM
sierra_view.patron_record as p
JOIN
temp_ready_for_pickup as t
ON
  t.patron_record_id = p.record_id
LEFT JOIN
sierra_view.checkout C
ON
p.record_id = C.patron_record_id
WHERE
p.ptype_code = 0
AND (p.owed_amt >= 100.00 OR p.mblock_code != '')

ORDER BY
p.owed_amt,
patron_record_id