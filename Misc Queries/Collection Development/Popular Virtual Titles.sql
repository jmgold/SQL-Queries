/*
Jeremy Goldstein
Minuteman Library Network

Identifies the most frequently requested virtual records
*/

SELECT
b.best_title_norm AS title,
b.best_author_norm AS author,
COUNT(i.id) AS total

FROM
sierra_view.item_record i
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id AND i.virtual_type_code = '$'
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.record_metadata rmb
ON
b.bib_record_id = rmb.id

WHERE rm.creation_date_gmt >= CURRENT_DATE - INTERVAL '1 YEAR'
GROUP BY 1,2
HAVING COUNT(i.id) > 1
ORDER BY 3 DESC