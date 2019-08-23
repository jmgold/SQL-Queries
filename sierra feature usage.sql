/*
Jeremy Goldstein
Minuteman Library Network

Identifies which libraries use each module of Sierra
*/

SELECT
loc.name AS location,
CASE
	WHEN COUNT(o.*) > 20 THEN TRUE
	ELSE FALSE
END AS uses_acquisitions,
CASE
	WHEN COUNT(h.*) > 20 THEN TRUE
	ELSE FALSE
END AS uses_serials,
CASE
	WHEN COUNT(c.*) > 20 THEN TRUE
	ELSE FALSE
END AS uses_course_reserves

FROM
sierra_view.location_myuser loc
LEFT JOIN
sierra_view.order_record_cmf o
ON
loc.code = SUBSTRING(o.location_code,1,3)
LEFT JOIN
sierra_view.holding_record_location h
ON
loc.code = SUBSTRING(h.location_code,1,3)
LEFT JOIN
sierra_view.course_record c
ON
loc.code = SUBSTRING(c.location_code,1,3)

WHERE
loc.code ~ '^[a-z]{3}$'
GROUP BY 1
ORDER BY 1 

