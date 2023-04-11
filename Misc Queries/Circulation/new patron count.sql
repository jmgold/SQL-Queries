/*
Jeremy Goldstein
Minuteman Library Network

Provides daily counts of the number of new patrons registered for each ptype
*/

SELECT
pt.name AS ptype,
TO_CHAR(rm.creation_date_gmt,'Mon DD, yyyy') AS date,
COUNT(p.id) patrons_registered

FROM
sierra_view.patron_record p
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id AND rm.record_type_code = 'p'
JOIN
sierra_view.ptype_property_myuser pt
ON
p.ptype_code = pt.value

WHERE
rm.creation_date_gmt::DATE > (CURRENT_DATE - INTERVAL '30 days')
GROUP BY 1,2
ORDER BY 1,2