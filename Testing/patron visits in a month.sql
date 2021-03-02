SELECT
t.patron_record_id,
COUNT(DISTINCT t.transaction_gmt::DATE)

FROM
sierra_view.circ_trans t

JOIN
sierra_view.statistic_group_myuser s
ON
t.stat_group_code_num = s.code and s.location_code ~ '^fp'

WHERE
t.op_code = 'o'

GROUP BY 1
ORDER BY 2 DESC
