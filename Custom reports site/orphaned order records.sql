/*
Jeremy Goldstein
Minuteman Library Network

Identifies bib records where a library has attached a paid order record and 0 items
Limited to full monographic records

Is passed an owning location variable
*/

SELECT
DISTINCT id2reckey(b.bib_record_id)||'a' AS rec_num,
b.best_title AS title,
MAX(o.paid_date_gmt::DATE) AS paid_date
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record br
ON
b.bib_record_id = br.id AND br.bcode1 = 'm' AND br.bcode3 NOT IN ('b','g','c','z')
JOIN
sierra_view.bib_record_order_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.order_record_paid o
ON
l.order_record_id = o.order_record_id
JOIN
sierra_view.order_record_cmf cmf
ON
o.order_record_id = cmf.order_record_id AND cmf.location_code ~ {{Location}}
JOIN
sierra_view.order_record ord
ON l.order_record_id = ord.id AND ord.order_status_code = 'a'
WHERE NOT EXISTS (
SELECT l.id
FROM
sierra_view.bib_record_item_record_link l
JOIN
sierra_view.item_record i 
ON l.item_record_id = i.id
AND b.bib_record_id = l.bib_record_id AND i.location_code ~ {{Location}}
)
AND EXISTS(
SELECT l.id
FROM
sierra_view.bib_record_order_record_link l
JOIN
sierra_view.order_record o
ON l.order_record_id = o.id
AND
b.bib_record_id = l.bib_record_id AND o.order_status_code = 'a'
JOIN
sierra_view.order_record_cmf cmf
ON
o.id = cmf.order_record_id AND cmf.location_code ~ {{Location}}

)
GROUP BY 1,2
ORDER BY 3;