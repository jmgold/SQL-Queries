SELECT

b.date,
b.title,
b.hold_count

FROM
(SELECT
a.date,
a.title,
a.hold_count,
RANK() OVER (PARTITION BY a.date ORDER BY a.hold_count DESC) AS "rank"

FROM
(SELECT
h.placed_gmt::DATE AS "date",
b.best_title AS title,
COUNT(DISTINCT h.id) AS hold_count
--RANK() OVER (PARTITION BY h.placed_gmt::DATE, b.best_title ORDER BY COUNT(DISTINCT h.id) DESC) AS "rank"

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

WHERE
h.placed_gmt::DATE >= '2020-03-01'
GROUP BY 1,2)a)b

WHERE
b.rank <= 25
