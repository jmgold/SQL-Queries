SELECT
C.transaction_gmt::DATE,
c.application_name,
COUNT(C.id)
FROM
sierra_view.circ_trans C
WHERE
C.transaction_gmt >= NOW() - INTERVAL '1 month'
GROUP BY 1,2
ORDER BY 1,3 desc