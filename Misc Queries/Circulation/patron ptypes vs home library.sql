/*
Jeremy Goldstein
Minuteman Library Network
Gathers totals for how many patrons in each ptype have set a different location as their home library
*/
SELECT 
SPLIT_PART(pt.name,' ',1) AS ptype,
INITCAP(SPLIT_PART(l.name,'/',1))
AS home,
COUNT(p.id)
FROM
sierra_view.patron_record p
JOIN
sierra_view.location_myuser l
ON
SUBSTRING(p.home_library_code,1,3) = l.code
JOIN
sierra_view.ptype_property_myuser pt
ON
p.ptype_code = pt.value

WHERE
p.ptype_code NOT IN ('9','13','16','19','42','43','44','45','47','116') AND p.ptype_code < 147

GROUP BY 1,2
HAVING SPLIT_PART(pt.name,' ',1) != INITCAP(SPLIT_PART(l.name,'/',1))

ORDER BY 1,2