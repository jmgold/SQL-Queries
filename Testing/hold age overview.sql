SELECT
h.pickup_location_code,
m.name AS format,
COUNT(DISTINCT h.id) AS total_holds,
ROUND(AVG(CURRENT_DATE - h.placed_gmt::DATE)) AS avg_hold_age,
MODE() WITHIN GROUP (ORDER BY (CURRENT_DATE - h.placed_gmt::DATE)) AS mode_hold_age,
ROUND(percentile_cont(0.5) WITHIN GROUP (ORDER BY (CURRENT_DATE - h.placed_gmt::DATE))) AS median_hold_age,
MAX(CURRENT_DATE - h.placed_gmt::DATE) AS max_hold_age,
COUNT(DISTINCT h.id) FILTER (WHERE h.placed_gmt::DATE >= CURRENT_DATE - INTERVAL '1 day') "in_last_day",
COUNT(DISTINCT h.id) FILTER (WHERE h.placed_gmt::DATE >= CURRENT_DATE - INTERVAL '1 week') "in_last_week",
COUNT(DISTINCT h.id) FILTER (WHERE h.placed_gmt::DATE >= CURRENT_DATE - INTERVAL '1 month') "in_last_month",
COUNT(DISTINCT h.id) FILTER (WHERE h.placed_gmt::DATE >= CURRENT_DATE - INTERVAL '3 months') "in_last_quarter",
COUNT(DISTINCT h.id) FILTER (WHERE h.placed_gmt::DATE >= CURRENT_DATE - INTERVAL '1 year') "in_last_year"

FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.bib_record_id OR h.record_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.material_property_myuser m
ON
b.material_code = m.code

WHERE
m.code NOT IN ('b','h','l','w','s','y')
GROUP BY 1,2
ORDER BY 1,2