/*
Jeremy Goldstein
Minuteman Library Network

Gathers counts of active patrons from the past 90 days broken out by age
For use with Data studio chart
*/

SELECT
EXTRACT(YEAR FROM AGE(p.birth_date_gmt)) AS AGE,
CASE
WHEN p.ptype_code IN ('13', '163') THEN 'Framingham State'
WHEN p.ptype_code IN ('44', '194') THEN 'Pine Manor'
ELSE SPLIT_PART(pt.name, ' ', 1)
END AS library,
COUNT(p.id) FILTER(WHERE (NOW()::DATE - p.activity_gmt::DATE) > 90) AS not_active_90_days,
COUNT(p.id) FILTER(WHERE (NOW()::DATE - p.activity_gmt::DATE) <= 90) AS active_90_days

FROM
sierra_view.patron_record p
JOIN
sierra_view.ptype_property_myuser pt
ON
p.ptype_code = pt.value

WHERE
p.ptype_code NOT IN ('204','200','199','201','206','202','203','255','254','205')

GROUP BY 1,2
ORDER BY 1,2