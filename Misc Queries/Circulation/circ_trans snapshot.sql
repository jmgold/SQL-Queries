/*
Jeremy Goldstein
Minuteman Library Network
Gathers daily transactions totals by stat group
*/

SELECT
CASE
	WHEN C.op_code = 'i' AND C.transaction_gmt::TIME = '04:00:00' THEN to_char(i.last_checkin_gmt,'YYYY-MM-DD')
	ELSE to_char(c.transaction_gmt,'YYYY-MM-DD')
END AS DATE,
CASE
	--account for internal use counts made via mobile worklists
	WHEN c.stat_group_code_num = 992 AND c.op_code = 'u' AND u.name IS NOT NULL THEN u.statistic_group_code_num
	ELSE c.stat_group_code_num 
END AS stat_group,
COUNT(DISTINCT c.id) FILTER(WHERE c.op_code = 'o') AS checkouts,
COUNT(DISTINCT c.id) FILTER(WHERE c.op_code = 'i') AS checkins,
COUNT(DISTINCT c.id) FILTER(WHERE c.op_code = 'r') AS renewals,
COUNT(DISTINCT c.id) FILTER(WHERE c.op_code = 'u') AS use_count,
COUNT(DISTINCT c.id) FILTER(WHERE c.op_code = 'f') AS filled_hold,
COUNT(DISTINCT c.id) FILTER(WHERE c.op_code IN ('n','nb','ni','h','hb','hi')) AS hold_placed

FROM
sierra_view.circ_trans C
LEFT JOIN
sierra_view.item_record i
ON
C.item_record_id = i.id
--account for internal use counts made via mobile worklists
LEFT JOIN
sierra_view.iii_user u
ON
SUBSTRING(i.location_code,1,3) = SUBSTRING(u.name,1,3) AND u.name ~ 'lists'

WHERE (c.transaction_gmt::DATE >= NOW()::DATE - INTERVAL '1 day'
AND c.transaction_gmt::DATE != NOW()::DATE)
--accomodate backdating
OR (C.op_code = 'i' AND C.transaction_gmt::TIME = '04:00:00' AND i.last_checkin_gmt::DATE >= NOW()::DATE - INTERVAL '1 day'
AND i.last_checkin_gmt::DATE != NOW()::DATE)

GROUP BY 1,2
ORDER BY 1,2
