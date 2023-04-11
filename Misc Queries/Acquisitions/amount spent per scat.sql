/*
Jeremy Goldstein
Minuteman Library Network

Used to gather the amount spent on items broken down by scat code.  
Highly imperfect totals due to lack of direct connection between items and orders.
*/

SELECT
i.icode1 AS scat,
SUM(p.paid_amount)::MONEY AS total_spent

FROM
sierra_view.bib_record_item_record_link l
JOIN
sierra_view.item_record i
ON
--limit to library and orders created in a date range
l.item_record_id = i.id AND i.location_code ~ '^wat'
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id AND rm.creation_date_gmt::DATE >= '2022-07-01' 
JOIN
sierra_view.bib_record_order_record_link ol
ON
l.bib_record_id = ol.bib_record_id
JOIN
sierra_view.order_view o
ON
--limit to the same library as line 15
ol.order_record_id = o.id AND o.record_creation_date_gmt::DATE >= '2022-07-01' AND o.accounting_unit_code_num = '34'
JOIN
sierra_view.order_record_paid p
ON
o.id = p.order_record_id AND p.paid_date_gmt::DATE >= '2022-07-01'

GROUP BY 1
ORDER BY 1
