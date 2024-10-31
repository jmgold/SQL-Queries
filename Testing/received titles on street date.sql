SELECT
rm.record_type_code||rm.record_num||'a' AS bnumber,
b.best_title,
b.best_author,
SPLIT_PART(REPLACE(s.field_content,'|b',''),'|c',1) AS publisher,
COUNT(DISTINCT l.item_record_id) AS item_count,
COUNT(DISTINCT o.id) AS order_total,
COUNT(DISTINCT o.id) FILTER (WHERE o.order_status_code = 'a') AS received_order_count,
COUNT(DISTINCT o.id) FILTER (WHERE o.vendor_record_code LIKE '%b%') AS order_count_bt,
COUNT(DISTINCT o.id) FILTER (WHERE o.order_status_code = 'a' AND o.vendor_record_code LIKE '%b%') AS received_order_count_bt,
COUNT(DISTINCT o.id) FILTER (WHERE o.vendor_record_code LIKE '%i%') AS order_count_ing,
COUNT(DISTINCT o.id) FILTER (WHERE o.order_status_code = 'a' AND o.vendor_record_code LIKE '%i%') AS received_order_count_ing

FROM sierra_view.record_metadata rm
JOIN sierra_view.varfield s
	ON rm.id = s.record_id
	AND rm.record_type_code = 'b'
	AND s.marc_tag = '260'
	AND s.field_content ~ '20241029$'
JOIN sierra_view.bib_record_property b
	ON rm.id = b.bib_record_id
LEFT JOIN sierra_view.bib_record_item_record_link l
	ON b.bib_record_id = l.bib_record_id
LEFT JOIN sierra_view.bib_record_order_record_link ol
	ON b.bib_record_id = ol.bib_record_id
LEFT JOIN sierra_view.order_record o
	ON ol.order_record_id = o.id 

GROUP BY 1,2,3,4