/*
Jeremy Goldstein
Minuteman Library Network
Combines magazine count checkin and magazine count item queries
*/
SELECT
rm.record_type_code||rm.record_num||'a' AS bib_num,
bp.best_title AS title,
v.field_content AS checkin_rec_holdings,
SUM(hl.copies) AS checkin_rec_copies,
COALESCE(vi.field_content,'') AS item_rec_holdings,
COUNT(DISTINCT i.id) AS item_count

FROM
sierra_view.bib_record_property bp
JOIN
sierra_view.record_metadata rm
ON
bp.bib_record_id = rm.id
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
bh.holding_record_id = h.id AND h.accounting_unit_code_num = '6'
JOIN
sierra_view.holding_record_location hl
ON
h.id = hl.holding_record_id
LEFT JOIN
sierra_view.varfield v
ON
h.id = v.record_id AND varfield_type_code = 'h'
LEFT JOIN
sierra_view.varfield vi
ON
i.id = vi.record_id AND vi.varfield_type_code = 'v' AND i.item_status_code = 'j'

WHERE bp.material_code = '3'

GROUP BY 1,2,3,5
ORDER BY 2