SELECT
t.transaction_gmt::DATE AS checkout_date,
rmb.record_type_code||rmb.record_num||'a' AS bnumber,
mat.name AS mat_type,
b.best_title AS title,
b.best_author AS author,
SUBSTRING(t.item_location_code,1,3) AS owning_library,
COUNT(DISTINCT i.id) FILTER(WHERE i.location_code ~ '^wsn') AS locally_owned_copies,
COALESCE(SUM(cmf.copies),0) AS local_copies_on_order

FROM sierra_view.circ_trans t
JOIN sierra_view.bib_record_item_record_link l
  ON t.item_record_id = l.item_record_id
JOIN sierra_view.bib_record_property b
  ON l.bib_record_id = b.bib_record_id
JOIN sierra_view.record_metadata rmb
  ON b.bib_record_id = rmb.id
JOIN sierra_view.item_record i
  ON l.item_record_id = i.id
JOIN sierra_view.material_property_myuser mat
  ON b.material_code = mat.code
LEFT JOIN sierra_view.bib_record_order_record_link ol
  ON l.bib_record_id = ol.bib_record_id
LEFT JOIN sierra_view.order_record o
  ON ol.order_record_id = o.id
  AND o.accounting_unit_code_num = '39'
  AND o.order_status_code = 'o'
LEFT JOIN sierra_view.order_record_cmf cmf
  ON o.id = cmf.order_record_id
  
WHERE t.op_code = 'f'
  AND t.stat_group_code_num BETWEEN '800' AND '809'

GROUP BY 1,2,3,4,5,6
ORDER BY 1
