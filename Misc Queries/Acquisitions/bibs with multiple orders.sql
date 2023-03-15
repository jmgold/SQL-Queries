/*
Jeremy Goldstein
Minuteman Library Network

Identifies frequently ordered titles
*/

WITH bib_list AS(
SELECT 
l.bib_record_id,
COUNT(o.id)
FROM 
sierra_view.bib_record b
JOIN
sierra_view.bib_record_order_record_link AS l
ON
b.id = l.bib_record_id
JOIN
sierra_view.order_record_cmf as o
ON
o.order_record_id = l.order_record_id
AND o.location_code ~ '^blm'
JOIN
sierra_view.record_metadata m
ON
o.order_record_id = m.id AND m.creation_date_gmt >= '2021-05-28'

group by 1
having count(o.id) > 1
)

SELECT
ID2RECKEY(b.bib_record_id)||'a' AS bib_number,
b.best_title AS title,
b.best_author AS author,
id2reckey(l.order_record_id)||'a' AS order_number,
o.location_code,
rm.creation_date_gmt::DATE AS order_date,
o.copies

FROM
bib_list bl
JOIN
sierra_view.bib_record_property b
ON
bl.bib_record_id = b.bib_record_id
JOIN
sierra_view.bib_record_order_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.order_record_cmf o
ON
l.order_record_id = o.order_record_ID AND o.location_code ~ '^blm'
JOIN
sierra_view.record_metadata rm
ON
o.order_record_id = rm.id AND rm.creation_date_gmt >= '2021-05-28'

ORDER BY 1,5,6