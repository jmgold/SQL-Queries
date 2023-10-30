/*
Jeremy Goldstein
Minuteman Library Network

authors with books cataloged in both the fiction and mystery collections
*/
WITH author_list AS (
SELECT
DISTINCT REPLACE(b.best_author, ' author.','') AS author

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code ~ '^bl'
AND i.icode1 = '1' --fiction

INTERSECT

SELECT
DISTINCT REPLACE(b.best_author, ' author.','') AS author

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code ~ '^bl'
AND i.icode1 = '2' --mystery
)
SELECT
a.author,
COUNT(DISTINCT b.id) AS title_count,
COUNT(i.id) FILTER(WHERE i.icode1 = '1') AS fic_copies,
COUNT(i.id) FILTER(WHERE i.icode1 = '2') AS mys_copies

FROM
author_list a
JOIN
sierra_view.bib_record_property b
ON
a.author = REPLACE(b.best_author, ' author.','')
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code ~ '^bl'
AND i.icode1 IN ('1','2')

GROUP BY 1
ORDER BY 1