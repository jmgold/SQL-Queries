WITH wait_time AS (
SELECT
h.id,
CURRENT_DATE - h.placed_gmt::DATE AS wait_time
FROM
sierra_view.hold h
WHERE
h.status IN ('0','t')
)



SELECT
M.name AS mat_type,
loc.name AS library,
AVG(w.wait_time)::INT AS avg_wait_time,
AVG(w.wait_time) FILTER (WHERE hc.hold_count = 1)::INT AS avg_wait_time_1_hold,
AVG(w.wait_time) FILTER (WHERE hc.hold_count >= 10)::INT AS avg_wait_time_10plus_holds

FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.bib_record_id OR h.record_id = l.item_record_id
JOIN
wait_time w
ON
h.id = w.id
JOIN
sierra_view.location_myuser loc
ON
SUBSTRING(h.pickup_location_code,1,3) = loc.code
JOIN
sierra_view.record_metadata rm
ON
l.bib_record_id = rm.id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.material_property_myuser M
ON
b.material_code = M.code
JOIN
(SELECT
l.bib_record_id,
COUNT (DISTINCT h.id) AS hold_count
FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.bib_record_id OR h.record_id = l.item_record_id
GROUP BY 1)hc
ON
l.bib_record_id = hc.bib_record_id

WHERE h.is_frozen = 'FALSE'

GROUP BY 1,2
ORDER BY 1,2