/*
Jeremy Goldstein
Minuteman Library Network

Provides a current snapshot of the number items on hold for, in transit to or on the holdshelf at each location
Run daily during off hours to track activity over time
*/

SELECT
to_char(NOW(),'YYYY-MM-DD') AS "date",
l.name AS library,
CASE
	WHEN h.status = '0' THEN 'on hold'
	WHEN h.status = 't' THEN 'in transit'
	ELSE 'on holdshelf'
END AS status,
COUNT(h.id) AS total

FROM
sierra_view.hold h
JOIN
sierra_view.location_myuser l
ON
SUBSTRING(h.pickup_location_code,1,3) = l.code
GROUP BY 1,2,3
ORDER BY 2,3
