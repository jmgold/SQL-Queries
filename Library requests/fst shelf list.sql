SELECT
ip.barcode,
b.best_title AS title,
b.best_author AS author,
REGEXP_REPLACE(ip.call_number,'^\|a\s?','')||' '||COALESCE(v.field_content,'') AS call_number,
i.location_code,
i.item_status_code

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
LEFT JOIN
sierra_view.varfield v
ON
i.id = v.record_id AND v.varfield_type_code = 'v'

WHERE i.location_code ~ '^fst'
ORDER BY 4