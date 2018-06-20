SELECT
id2reckey(bp.bib_record_id)||'a' AS bib_num,
bp.best_title AS title,
v.field_content AS checkin_rec_holdings,
vi.field_content AS item_rec_holdings

FROM
sierra_view.bib_record_property bp
LEFT JOIN
sierra_view.bib_record_item_record_link bi
ON
bp.bib_record_id = bi.bib_record_id
JOIN
sierra_view.item_record i
ON
bi.item_record_id = i.id AND i.location_code LIKE 'act%' AND i.item_status_code NOT IN ('m', 'n', 'z', '$', 'w', 'd')
LEFT JOIN
sierra_view.bib_record_holding_record_link bh
ON
bp.bib_record_id = bh.bib_record_id
LEFT JOIN
sierra_view.holding_record h
ON
bh.holding_record_id = h.id AND h.accounting_unit_code_num = '1'
LEFT JOIN
sierra_view.varfield v
ON
h.id = v.record_id AND varfield_type_code = 'h'
LEFT JOIN
sierra_view.varfield vi
ON
i.id = vi.record_id AND vi.varfield_type_code = 'v' AND i.item_status_code = 'j'

WHERE bp.material_code = '3'

GROUP BY 1,2,3,4
ORDER BY 2