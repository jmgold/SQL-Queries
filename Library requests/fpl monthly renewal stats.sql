SELECT
--C.transaction_gmt::DATE,
c.application_name,
COUNT(C.id),
COUNT(C.id) FILTER (WHERE (C.loanrule_code_num BETWEEN '123' AND '133' OR C.loanrule_code_num BETWEEN '600' AND '608')) AS FPL_checkouts,
COUNT(C.id) FILTER (WHERE p.ptype_code = '12') AS FPL_ptype_checkouts
FROM
sierra_view.circ_trans C
JOIN
sierra_view.patron_record p
ON
C.patron_record_id = p.id
WHERE
C.transaction_gmt >= NOW() - INTERVAL '1 month' AND C.op_code = 'r'
GROUP BY 1
ORDER BY 2 desc