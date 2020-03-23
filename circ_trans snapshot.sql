SELECT
c.transaction_gmt::DATE AS DATE,
c.stat_group_code_num AS stat_group,

COUNT(c.id) FILTER(WHERE c.op_code = 'o') AS checkouts,
COUNT(c.id) FILTER(WHERE c.op_code = 'i') AS checkins,
COUNT(c.id) FILTER(WHERE c.op_code = 'r') AS renewals,
COUNT(c.id) FILTER(WHERE c.op_code = 'u') AS use_count,
COUNT(c.id) FILTER(WHERE c.op_code = 'f') AS filled_hold,
COUNT(c.id) FILTER(WHERE c.op_code IN ('n','nb','ni','h','hb','hi')) AS hold_placed

FROM
sierra_view.circ_trans C

WHERE c.transaction_gmt::DATE >= NOW()::DATE - INTERVAL '3 day'
AND c.transaction_gmt::DATE != NOW()::DATE

GROUP BY 1,2
ORDER BY 1,2