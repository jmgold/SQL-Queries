--Identifies patron records with invalid e-mail records, includes fields with excessive spaces.
SELECT
id2reckey(p.id)||'a' AS record_num,
p.barcode,
v.field_content as email
FROM
sierra_view.patron_view as p
JOIN		
sierra_view.varfield v		
ON		
p.id = v.record_id and varfield_type_code = 'z'
WHERE
v.field_content is not null and v.field_content !~ '(\@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-\.]+$)'
ORDER BY 1
