SELECT
rm.record_type_code||rm.record_num||'a' AS record_number,
b.language_code,
bp.material_code,
bp.best_title,
b.bcode3

FROM
sierra_view.bib_record b
LEFT JOIN
sierra_view.control_field f
ON
b.id = f.record_id AND f.control_num = 8
JOIN
sierra_view.record_metadata rm
ON
b.id = rm.id
JOIN
sierra_view.bib_record_property bp
ON
b.id = bp.bib_record_id

WHERE f.id IS NULL
AND b.language_code !~ '(^eng|^zxx|^und)'
AND b.language_code !=''
AND b.is_suppressed = FALSE
AND b.bcode3 NOT IN ('c', 'n', 'o', 'q', 'r', 'z')
ORDER BY 1
--LIMIT 100