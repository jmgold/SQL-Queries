SELECT
SUBSTRING(p.home_library_code,1,3) AS home_library,
COUNT(DISTINCT p.id) AS Total_patrons,
COUNT(DISTINCT h.patron_record_id) FILTER (WHERE h.id IS NOT NULL) AS patrons_with_holds,
COUNT(DISTINCT h.patron_record_id) FILTER (WHERE h.placed_gmt::DATE >= NOW()::DATE - INTERVAL '30 DAYS') AS patrons_with_holds_past_month,
COUNT(DISTINCT h.patron_record_id) FILTER (WHERE h.placed_gmt::DATE >= NOW()::DATE - INTERVAL '7 DAYS') AS patrons_with_holds_past_week,
COUNT(DISTINCT h.patron_record_id) FILTER (WHERE h.placed_gmt::DATE >= NOW()::DATE - INTERVAL '1 DAY') AS patrons_with_holds_yesterday,
COUNT(DISTINCT l.bib_record_id) AS unique_titles



FROM
sierra_view.patron_record p
LEFT JOIN
sierra_view.hold h
ON
p.id = h.patron_record_id
LEFT JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.item_record_id OR h.record_id = l.bib_record_id

GROUP BY 1
ORDER BY 1