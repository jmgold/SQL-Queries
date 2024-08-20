/*
Jeremy Goldstein
Minuteman Library Network

Identifies which libraries use each module of Sierra
*/

SELECT
loc.name AS location,
CASE
	WHEN COUNT(o.*) FILTER(WHERE rm.creation_date_gmt >= CURRENT_DATE - INTERVAL '1 year') > 20 THEN TRUE
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
sierra_view.record_metadata rm
ON
o.order_record_id = rm.id AND rm.creation_date_gmt::DATE >= CURRENT_DATE - INTERVAL '1 year'
LEFT JOIN
sierra_view.holding_record_location h
ON
loc.code = SUBSTRING(h.location_code,1,3)
LEFT JOIN
sierra_view.course_record c
ON
loc.code = SUBSTRING(c.location_code,1,3)

WHERE
loc.code ~ '^[a-z0-9]{3}$'

GROUP BY 1
ORDER BY 1



