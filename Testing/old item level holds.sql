SELECT
DISTINCT id2reckey(i.id)||'a' AS item_number,
i.location_code,
REGEXP_REPLACE(ip.call_number,'\|[a-z]','')AS call_number,
v.field_content AS volume,
b.best_title AS title,
s.name AS status,
ip.barcode AS barcode,
it.name AS itype
FROM
sierra_view.hold h
JOIN
sierra_view.item_record i
ON
h.record_id = i.id AND i.location_code ~ '^som' AND i.item_status_code != '!' AND i.itype_code_num NOT IN ('5','6','221','222','223','224','242')
LEFT JOIN
sierra_view.checkout o
ON
i.id = o.item_record_id
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.varfield v
ON
i.id = v.record_id AND v.varfield_type_code = 'v'
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code
JOIN
sierra_view.item_status_property_myuser s
ON
i.item_status_code = s.code

WHERE
h.status = '0' AND h.is_frozen = 'false' AND CURRENT_DATE > (h.placed_gmt::DATE + h.delay_days) AND h.placed_gmt::DATE <(CURRENT_DATE - INTERVAL '2 weeks')
AND o.id IS NULL

ORDER BY 2,6,3,4