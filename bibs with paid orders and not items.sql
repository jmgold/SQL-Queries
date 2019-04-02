SELECT
id2reckey(b.id)||'a' AS rec_num
FROM
sierra_view.bib_record b
WHERE NOT EXISTS (
SELECT l.id
FROM
sierra_view.bib_record_item_record_link l
JOIN
sierra_view.item_record i 
ON l.item_record_id = i.id
AND b.id = l.bib_record_id AND i.location_code LIKE 'ntn%'
)
AND EXISTS(
SELECT l.id
FROM
sierra_view.bib_record_order_record_link l
JOIN
sierra_view.order_record o
ON l.order_record_id = o.id
AND
b.id = l.bib_record_id AND o.order_status_code = 'a' AND o.accounting_unit_code_num = '30'
)
ORDER BY 1;