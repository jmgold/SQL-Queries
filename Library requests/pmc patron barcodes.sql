SELECT
rm.record_type_code||rm.record_num||'a' AS patron_number,
n.first_name||' '||n.middle_name||' '||n.last_name AS NAME,
b.index_entry AS barcode,
id.field_content AS student_id

FROM
sierra_view.patron_record p
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id AND rm.creation_date_gmt::DATE >= (NOW() - INTERVAL '4 years')
JOIN
sierra_view.phrase_entry b
ON
p.id = b.record_id AND b.index_tag = 'b'
JOIN
sierra_view.varfield id
ON
p.id = id.record_id AND id.varfield_type_code = 'r'
JOIN
sierra_view.patron_record_fullname n
ON
p.id = n.patron_record_id

WHERE
p.ptype_code IN ('44', '194')