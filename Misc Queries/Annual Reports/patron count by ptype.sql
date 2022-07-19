SELECT
p.ptype_code AS PType,
n.name AS PType_Label,
COUNT(p.id) AS Total_Patrons,
COUNT(p.id) FILTER(WHERE p.activity_gmt > (localtimestamp - INTERVAL '1 year')) AS Active_Patrons,
COUNT(p.id) FILTER(WHERE m.creation_date_gmt > (localtimestamp - INTERVAL '1 year')) AS New_Patrons
FROM
sierra_view.patron_view p
JOIN
sierra_view.ptype_property_myuser n
ON
p.ptype_code = n.value
JOIN
sierra_view.record_metadata m
ON
p.record_num = m.record_num and m.record_type_code = 'p'
GROUP BY 1,2
ORDER BY 2
