SELECT
h.placed_gmt::DATE AS "DATE",
b.best_title AS TITLE,
COUNT(DISTINCT h.id) AS HOLDS

FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.bib_record_id OR h.record_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id AND b.material_code = 'a'

WHERE
h.placed_gmt >= '2020-01-01'

GROUP BY 1,2
ORDER BY 1,3 DESC