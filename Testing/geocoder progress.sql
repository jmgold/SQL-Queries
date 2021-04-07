SELECT
p.ptype_code,
pt.name AS ptype_name,
COUNT(p.id) FILTER(WHERE v.field_content IS NOT NULL) AS total_complete,
COUNT(p.id) FILTER(WHERE v.field_content IS NULL) AS total_to_do
FROM
sierra_view.patron_record p
JOIN
sierra_view.ptype_property_myuser pt
ON
p.ptype_code = pt.value
LEFT JOIN
sierra_view.varfield v
ON
p.id = v.record_id AND v.varfield_type_code = 'k' --AND p.ptype_code = '34'

GROUP BY 1,2
ORDER BY 2