SELECT
'b'||b.record_id||'a' AS "Record_number",
bp.best_title AS "Title",
bp.best_author AS "Author",
bp.publish_year AS "Publication_year",
bp.material_code AS "MatType",
COUNT(h.id) AS "Total_holds",
COUNT(CASE WHEN h.pickup_location_code LIKE 'act%' then 1 ELSE NULL END) AS "Local_holds",
COUNT(bi.id) AS "Total_items",
COUNT(CASE WHEN i.location_code LIKE 'act%' THEN 1 ELSE NULL END) AS "Local_items",
SUM(ocmf.copies) AS "Copies_on_order"
FROM
sierra_view.bib_record AS b
JOIN sierra_view.bib_record_property AS bp
ON b.id=bp.bib_record_id
LEFT JOIN sierra_view.bib_record_item_record_link AS bi 
ON bi.bib_record_id=b.id
JOIN sierra_view.item_record AS i
ON bi.item_record_id=i.id
JOIN sierra_view.hold AS h
ON (h.record_id=b.id OR h.record_id=bi.item_record_id)
LEFT JOIN sierra_view.bib_record_order_record_link AS bo
ON bo.bib_record_id=b.id
LEFT JOIN sierra_view.order_record as o
ON bo.order_record_id=o.id AND o.order_status_code='o' AND o.accounting_unit_code_num = '1'
LEFT JOIN sierra_view.order_record_cmf AS ocmf
ON o.id=ocmf.order_record_id
WHERE
h.status='0' AND h.is_frozen='FALSE'
GROUP BY 1, 2, 3, 4, 5
HAVING count(DISTINCT h.id)>0
LIMIT 100;