SELECT
DISTINCT rm.record_type_code||rm.record_num||'a' AS bib_number,
b.best_title,
b.best_author,
COUNT(DISTINCT i.id) AS item_total,
COUNT(DISTINCT o.id) AS order_total,
COUNT(DISTINCT o.id) FILTER (WHERE o.order_status_code IN ('o','q')) AS open_order_total,
SUM(i.checkout_total + i.renewal_total) AS total_circ

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id
/*JOIN
sierra_view.phrase_entry d
ON
b.bib_record_id = d.record_id AND d.index_tag = 'd'
AND d.is_permuted = FALSE AND d.index_entry ~ '(comic books strips etc)|(graphic novels)'*/
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
LEFT JOIN
sierra_view.item_record_property ip
ON
l.item_record_id = ip.item_record_id AND ip.call_number_norm ~ '^graphic'
LEFT JOIN
sierra_view.item_record i
ON
ip.item_record_id = i.id AND i.location_code ~ '^so' AND i.itype_code_num <= '7'
LEFT JOIN
sierra_view.bib_record_order_record_link ol
ON
b.bib_record_id = ol.bib_record_id
LEFT JOIN
sierra_view.order_record o
ON
ol.order_record_id = o.id AND o.accounting_unit_code_num = '31'
LEFT JOIN
sierra_view.order_record_cmf cmf
ON
o.id = cmf.order_record_id AND cmf.location_code ~ '^som'
JOIN
sierra_view.fund_master fm
ON
cmf.fund_code::INT = fm.code_num AND fm.accounting_unit_id = '32' AND fm.code IN ('cagra','cagrahub')

GROUP BY 1,2,3
LIMIT 500