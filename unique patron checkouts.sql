/*
Jeremy Goldstein
Minuteman Library Network

Monthly checkouts with unique patron count
*/

SELECT
c.transaction_gmt::DATE,
COUNT(c.id) AS total_checkouts,
COUNT(DISTINCT(c.patron_record_id)) AS total_unique_patrons,
ROUND(COUNT(c.id)::NUMERIC/COUNT(DISTINCT(c.patron_record_id)),2) AS avg_checkouts_per_patron
FROM
sierra_view.circ_trans c
JOIN
sierra_view.statistic_group_myuser s
ON
c.stat_group_code_num = s.code
where
c.op_code = 'o'
and
c.transaction_gmt > NOW()::DATE - INTERVAL '1 month'
and s.location_code LIKE 'arl%'
GROUP BY 1
ORDER BY 1