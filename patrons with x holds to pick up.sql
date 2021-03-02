/*
Jeremy Goldstein
Minuteman Library network

Created by request for Arlington to catch patrons with a large number of holds to pick up each day
*/

WITH patron_list AS
	(
	SELECT
	h.patron_record_id,
	COUNT(h.id)
	FROM
	sierra_view.hold h

	WHERE
	h.status IN ('b','i') AND h.pickup_location_code ~ '^arl'

	GROUP BY 1
	HAVING COUNT(h.id) >= 20
	)
	
SELECT
id2reckey(p.patron_record_id)||'a' AS pnumber,
n.first_name||' '||n.middle_name||' '||n.last_name AS name

FROM
patron_list p
JOIN
sierra_view.patron_record_fullname n
ON
p.patron_record_id = n.patron_record_id