/*
Jeremy Goldstein
Minuteman Library Network
Gathers daily transactions totals by stat group
*/

SELECT
--account for backdated checkins
CASE
	WHEN C.op_code = 'i' AND C.transaction_gmt::TIME = '04:00:00' THEN to_char(i.last_checkin_gmt,'YYYY-MM-DD')
	ELSE to_char(c.transaction_gmt,'YYYY-MM-DD')
END AS Date,
c.stat_group_code_num AS stat_group,
COUNT(c.id) FILTER(WHERE c.op_code = 'o') AS checkouts,
COUNT(c.id) FILTER(WHERE c.op_code = 'i') AS checkins,
COUNT(c.id) FILTER(WHERE c.op_code = 'r') AS renewals,
COUNT(c.id) FILTER(WHERE c.op_code = 'u') AS use_count,
COUNT(c.id) FILTER(WHERE c.op_code = 'f') AS filled_hold,
COUNT(c.id) FILTER(WHERE c.op_code IN ('n','nb','ni','h','hb','hi')) AS hold_placed

FROM
sierra_view.circ_trans C
JOIN
sierra_view.item_record i
ON
C.item_record_id = i.id

WHERE (c.transaction_gmt::DATE >= NOW()::DATE - INTERVAL '1 day'
AND c.transaction_gmt::DATE != NOW()::DATE)
---accomodate backdating
OR (C.op_code = 'i' AND C.transaction_gmt::TIME = '04:00:00' AND i.last_checkin_gmt::DATE >= NOW()::DATE - INTERVAL '1 day'
AND i.last_checkin_gmt::DATE != NOW()::DATE)

GROUP BY 1,2
ORDER BY 1,2
