SELECT
id2reckey(bp.bib_record_id)||'a' AS bib_num,
bp.best_title AS title,
string_agg(distinct(i.location_code), ',') AS item_locations,
COALESCE(vi.field_content,'') AS item_rec_holdings

FROM
sierra_view.bib_record_property bp
JOIN
sierra_view.bib_record_item_record_link bi
ON
bp.bib_record_id = bi.bib_record_id
JOIN
sierra_view.item_record i
ON bi.item_record_id = i.id AND i.location_code LIKE 'br%' AND i.item_status_code NOT IN ('m', 'n', 'z', '$', 'w', 'd')
LEFT JOIN
sierra_view.varfield vi
ON
i.id = vi.record_id AND vi.varfield_type_code = 'v' AND i.item_status_code = 'j'

WHERE bp.material_code = '3'

GROUP BY 1,2,4

ORDER BY 2