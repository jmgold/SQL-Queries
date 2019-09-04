SELECT
b.best_title,
id2reckey(i.id)||'a' AS item_number,
i.location_code

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.checkout_total < 2 AND i.item_status_code NOT IN ('o','e','w','p','r','q')
JOIN
sierra_view.record_metadata m
ON
i.id = m.id AND m.campus_code = '' AND m.creation_date_gmt BETWEEN (NOW()::DATE - INTERVAL '2 years') AND (NOW()::DATE - INTERVAL '1 year')

WHERE
b.material_code = 'a'
ORDER BY 3,1