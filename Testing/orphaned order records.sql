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


WHERE 
EXISTS
(SELECT 1
FROM
sierra_view.order_record_cmf cmf
WHERE
o.order_record_id = cmf.order_record_id AND cmf.location_code ~ '^fp'
)

AND NOT EXISTS (
SELECT 1 
FROM
sierra_view.bib_record_item_record_link bl
JOIN
sierra_view.item_record i 
ON
bl.item_record_id = i.id AND i.location_code ~ '^fp'
WHERE
l.bib_record_id = bl.bib_record_id
)

GROUP BY 1,2
ORDER BY 3;