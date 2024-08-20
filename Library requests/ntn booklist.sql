SELECT
b.best_title,
b.best_author,
SUM(i.last_year_to_date_checkout_total) AS FY23_checkout_total
FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id AND i.location_code ~ '^ntn'
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id

WHERE i.itype_code_num BETWEEN 150 AND 159
--b.material_code IN ('5','u')

GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 100;