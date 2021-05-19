SELECT 

v.field_content AS family_id,
COUNT(p.id),
STRING_AGG(id2reckey(p.id)||'a',',')

FROM
sierra_view.varfield v
JOIN
sierra_view.patron_record p
ON
v.record_id = p.id
WHERE
v.varfield_type_code = '1'

GROUP BY 1
HAVING COUNT(p.id) = 1
ORDER BY 2