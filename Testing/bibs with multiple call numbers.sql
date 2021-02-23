/*
Jeremy Goldstein
Minuteman Library Network

Identifies bibs where a library owns multiple items that have different call numbers
*/

SELECT
inner_query.bib_number,
inner_query.best_title,
item_count

FROM
(
SELECT
id2reckey(b.bib_record_id)||'a' AS bib_number,
b.best_title,
COUNT(*) AS item_count,
(COUNT(DISTINCT ip.call_number_norm) = 1) AS unique_count

FROM
sierra_view.item_record i
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id

WHERE
i.location_code ~'^cam'

GROUP BY 1,2
)inner_query

WHERE
inner_query.unique_count = false