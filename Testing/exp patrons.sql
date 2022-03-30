SELECT
rm.record_type_code||rm.record_num||'a' AS rec_num,
p.ptype_code,
p.expiration_date_gmt::DATE - rm.creation_date_gmt::DATE AS days_between,
p.expiration_date_gmt::DATE AS exp_date,
rm.creation_date_gmt::DATE AS creation_date,
message.field_content AS message,
note.field_content AS note

FROM
sierra_view.patron_record p
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id AND rm.creation_date_gmt::DATE >= '2020-02-01'
AND p.patron_agency_code_num != '47' AND p.expiration_date_gmt::DATE - rm.creation_date_gmt::DATE < (365*2)
AND p.ptype_code NOT IN ('9','13','16','44','45','47','116','147','159','163','166','175','194','195','197')
LEFT JOIN
sierra_view.varfield message
ON
p.id = message.record_id AND message.varfield_type_code = 'm'
LEFT JOIN
sierra_view.varfield note
ON
p.id = note.record_id AND note.varfield_type_code = 'x'

ORDER BY 4