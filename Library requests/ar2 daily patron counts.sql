SELECT
t.transaction_gmt::DATE AS DATE,
COUNT(t.id) AS checkout_total,
COUNT(DISTINCT t.patron_record_id) AS unique_patron_total,
COUNT(DISTINCT t.patron_record_id) FILTER(WHERE t.ptype_code IN ('2','302')) AS unique_ARL_patron_total,
COUNT(DISTINCT t.patron_record_id) FILTER(WHERE t.ptype_code NOT IN ('2','302')) AS unique_nonARL_patron_total

FROM
sierra_view.circ_trans t

WHERE
t.op_code = 'o' AND t.stat_group_code_num::VARCHAR ~ '^12[0-9]$'

GROUP BY 1
ORDER BY 1