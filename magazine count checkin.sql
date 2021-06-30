SELECT
id2reckey(bp.bib_record_id)||'a' AS bib_num,
bp.best_title AS title,
string_agg(DISTINCT(hl.location_code), ',') AS checkin_rec_location,
hl.copies AS checkin_rec_copies,
v.field_content AS checkin_rec_holdings

FROM
sierra_view.bib_record_property bp
JOIN
sierra_view.bib_record_holding_record_link bh
ON
bp.bib_record_id = bh.bib_record_id
JOIN
sierra_view.holding_record h
ON
bh.holding_record_id = h.id AND h.accounting_unit_code_num = '1'
JOIN
sierra_view.holding_record_location hl
ON
h.id = hl.holding_record_id
LEFT JOIN
sierra_view.varfield v
ON
h.id = v.record_id AND varfield_type_code = 'h'

WHERE bp.material_code = '22'

GROUP BY 1,2,5,4

ORDER BY 2


