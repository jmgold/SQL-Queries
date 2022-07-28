WITH payments AS (
SELECT
bo.bib_record_id,
SUM(p.paid_amount) AS paid_amount,
SUM(p.copies) AS copies_paid

FROM
sierra_view.order_record_paid p
JOIN
sierra_view.order_record o
ON
p.order_record_id = o.id AND o.accounting_unit_code_num = '17' AND p.paid_date_gmt::DATE BETWEEN '2021-07-01' AND '2022-06-30'
JOIN
sierra_view.bib_record_order_record_link bo
ON
o.id = bo.order_record_id

GROUP BY 1
),
items AS (
SELECT
bi.bib_record_id,
STRING_AGG(DISTINCT i.icode1::VARCHAR, ',') AS scat,
COUNT(i.id) AS item_total,
SUM(i.checkout_total + i.renewal_total) AS total_circ

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link bi
ON
i.id = bi.item_record_id AND i.location_code ~ '^lex'
JOIN
sierra_view.record_metadata rmi
ON
i.id = rmi.id AND rmi.creation_date_gmt::DATE BETWEEN '2021-07-01' AND '2022-06-30'

GROUP BY 1
)

SELECT
DISTINCT i.scat,
SUM(i.item_total) AS items_added,
SUM(p.copies_paid) AS copies_paid,
SUM(p.paid_amount)::MONEY AS paid_total,
SUM(i.total_circ) AS total_circ,
ROUND(SUM(p.paid_amount)/NULLIF(SUM(i.total_circ),0),2)::MONEY AS cost_per_circ

FROM
payments p
JOIN
items i
ON
p.bib_record_id = i.bib_record_id

GROUP BY 1
/*
UNION

SELECT
'unmatched payments' AS scat,
NULL AS items_added,
SUM(p.copies_paid)  AS copies_paid,
SUM(p.paid_amount)::MONEY AS paid_total,
NULL AS total_circ,
NULL AS cost_per_circ

FROM
payments p

WHERE p.bib_record_id NOT IN (
SELECT
i.bib_record_id
FROM items i
)

UNION

SELECT
'unmatched items' AS scat,
SUM(i.item_total) AS items_added,
NULL  AS copies_paid,
NULL AS paid_total,
SUM(i.total_circ) AS total_circ,
NULL AS cost_per_circ

FROM
items i

WHERE i.bib_record_id NOT IN (
SELECT
p.bib_record_id
FROM payments p
)
*/
ORDER BY 1
