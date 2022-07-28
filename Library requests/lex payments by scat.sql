WITH payments AS (
SELECT
bo.bib_record_id,
SUM(p.paid_amount)::MONEY AS paid_amount,
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
COUNT(i.id) AS item_total

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
SUM(p.paid_amount)::MONEY AS paid_total

FROM
payments p
JOIN
items i
ON
p.bib_record_id = i.bib_record_id

GROUP BY 1

ORDER BY 1
