SELECT
pt.value AS ptype_code,
pt.name AS ptype_name,
l.code AS location_code,
l.name AS location_name,
COUNT(p.id) AS patron_total,
COUNT(DISTINCT o.id) AS checkout_total

FROM
sierra_view.ptype_property_myuser pt
LEFT JOIN
sierra_view.location_myuser l
ON
UPPER(REGEXP_REPLACE(REGEXP_REPLACE(pt.name,'Fram State|Fram. State','Framingham STATE'),' (eCard|Exempt|Faculty|Student|Teacher|Homebound|CrossReg Student)','')) = REGEXP_REPLACE(l.name,' (COLLEGE|UNIVERSITY)','')
JOIN
sierra_view.patron_record p
ON
pt.value = p.ptype_code
LEFT JOIN
sierra_view.checkout o
ON
p.id = o.patron_record_id

WHERE pt.name != ''

GROUP BY 1,2,3,4

ORDER BY 4,2