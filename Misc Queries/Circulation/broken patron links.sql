/*
Jeremy Goldstein
Minuteman Library Network

Identifies patron records with broken patron record links
These display in the client as only being linked to themselves
*/

SELECT 
v.field_content AS family_id,
id2reckey(p.id)||'a' AS patron_number

FROM
sierra_view.varfield v
JOIN
sierra_view.patron_record p
ON
v.record_id = p.id AND v.varfield_type_code = '1'

GROUP BY 1
HAVING COUNT(p.id) = 1