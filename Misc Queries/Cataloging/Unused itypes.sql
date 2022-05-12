/*
Jeremy Goldstein
Minuteman Library Network
Identifies itypes that are not used by any items

Adapted from query by Brent Searle. Langara College. 2016-07-06
*/
SELECT
it.code AS itypecode
,it.name AS itype_name
  
FROM
sierra_view.itype_property_myuser it
LEFT JOIN
sierra_view.item_record i
ON
i.itype_code_num = it.code 
--Optional location limit
--AND i.location_code ~ '^ntn'

WHERE
it.name != '' 

GROUP BY 1,2

HAVING
SUM(CASE
	WHEN i.itype_code_num IS NULL THEN 0
   ELSE 1
END) = 0

ORDER BY
it.code

