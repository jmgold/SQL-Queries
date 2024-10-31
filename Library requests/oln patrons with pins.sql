SELECT
COUNT(DISTINCT p.id) AS total_patrons,
COUNT(DISTINCT p.id) FILTER(WHERE v.field_content IS NOT NULL) AS total_with_pins

FROM
sierra_view.patron_record p
LEFT JOIN
sierra_view.varfield v
ON
p.id = v.record_id AND v.varfield_type_code = '='
WHERE
p.ptype_code IN ('47','147','197')