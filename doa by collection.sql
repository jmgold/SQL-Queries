SELECT
SUBSTRING(i.location_code,1,3),
--b.material_code,
COUNT(i.id),
COUNT(i.id) FILTER (WHERE i.checkout_total < 2),
1.0 * COUNT(i.id) FILTER (WHERE i.checkout_total < 2) / COUNT(i.id)

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.item_status_code NOT IN ('o','e','w','p','r','q')
JOIN
sierra_view.record_metadata m
ON
i.id = m.id AND m.campus_code = '' AND m.creation_date_gmt BETWEEN (NOW()::DATE - INTERVAL '2 years') AND (NOW()::DATE - INTERVAL '1 year')

WHERE
b.material_code = 'j'
GROUP BY 1
ORDER BY 4 desc