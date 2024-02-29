/*
Jeremy Goldstein
Minuteman Library Network
Looks at renewals that were triggered by auto notices as a means of capturing 
the start/end/duration for the autonotice job each day.
*/

SELECT
t.transaction_gmt::DATE AS "DATE",
MIN(t.transaction_gmt) AS start_time,
MAX(t.transaction_gmt) AS end_time,
MAX(t.transaction_gmt) - MIN(t.transaction_gmt) AS duration,
COUNT(t.id) AS renewal_count,
EXTRACT('EPOCH' FROM (MAX(t.transaction_gmt) - MIN(t.transaction_gmt)))/COUNT(t.id) AS sec_per_renewal
FROM
sierra_view.circ_trans t
WHERE
t.op_code = 'r' AND t.application_name  = 'autonotices'
GROUP BY 1
ORDER BY 1