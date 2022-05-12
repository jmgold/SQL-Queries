/*
Jeremy Goldstein
Minuteman Library Network
Identifies ptypes that are not used by any patrons

Adapted from query by Brent Searle. Langara College. 2016-07-06
*/

SELECT
pt.value AS ptypecode
,pt.name AS ptype_name
  
FROM
sierra_view.ptype_property_myuser pt
LEFT JOIN
sierra_view.patron_record p
ON
p.ptype_code = pt.value 

WHERE
pt.name != '' 

GROUP BY 1,2

HAVING
SUM(CASE
	WHEN p.ptype_code IS NULL THEN 0
   ELSE 1
END) = 0

ORDER BY
pt.value
