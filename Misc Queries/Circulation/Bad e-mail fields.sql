/*
Jeremy Goldstein
Minuteman Library Network
Identifies patron records with possibly invalid e-mail addresses based on regex pattern matching.
*/

SELECT
p.record_type_code||p.record_num||'a' AS record_num,
p.barcode,
v.field_content AS email

FROM
sierra_view.patron_view AS p
JOIN		
sierra_view.varfield v		
ON		
p.id = v.record_id AND varfield_type_code = 'z'

WHERE
v.field_content IS NOT NULL 
AND TRIM(SPLIT_PART(REPLACE(v.field_content,';',','),',',1)) !~ '^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'
ORDER BY 1