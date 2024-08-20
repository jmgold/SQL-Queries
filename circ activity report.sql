SELECT
t.transaction_gmt::DATE,
t.stat_group_code_num,
s.name,
COUNT(t.id) FILTER(WHERE t.op_code IN ('o','r')) AS Combined_circ,
COUNT(t.id) FILTER(WHERE t.op_code = 'o') AS checkouts,
COUNT(t.id) FILTER(WHERE t.op_code = 'r') AS renewals,
COUNT(t.id) FILTER(WHERE t.op_code = 'i') AS checkins,
COUNT(t.id) FILTER(WHERE t.op_code ~ '^n') AS holds,
COUNT(t.id) FILTER(WHERE t.op_code ~ '^h') AS holds_recall,
COUNT(t.id) FILTER(WHERE t.op_code IN ('o','r','i') OR t.op_code ~ '^n|h') AS total

FROM
sierra_view.circ_trans t
JOIN
sierra_view.statistic_group_myuser s
ON
t.stat_group_code_num=s.code

WHERE t.transaction_gmt::DATE BETWEEN '06-01-2023' AND '06-30-2023'
GROUP BY 1,2,3
ORDER BY 1,3