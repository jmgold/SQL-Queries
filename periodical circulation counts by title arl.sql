SELECT
bp.best_title AS title,
SUM(i.last_year_to_date_checkout_total) + SUM(i.year_to_date_checkout_total) AS ytd_plus_lytd_checkout

FROM
sierra_view.bib_record b
JOIN
sierra_view.bib_record_property bp
ON
b.id = bp.bib_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
b.id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id =i.id AND i.location_code ~ '^arl'

WHERE
b.bcode3 = 'a'

GROUP BY 1
ORDER BY 1