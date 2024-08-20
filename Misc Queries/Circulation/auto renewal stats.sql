/*
Jeremy Goldstein
Minuteman Library Network

Counts renewals each day for the past month, broken out by the application used for the renewal
*/

SELECT
C.transaction_gmt::DATE,
COUNT(C.id) AS total_renewals,
COUNT(C.id) FILTER(WHERE c.application_name = 'autonotices') AS total_autorenewals,
COUNT(C.id) FILTER(WHERE c.application_name = 'webpac') AS total_online_renewals,
COUNT(C.id) FILTER(WHERE c.application_name = 'sierra') AS total_sierra,
COUNT(C.id) FILTER(WHERE c.application_name IN ('selfcheck','milmyselfcheck')) AS total_selfcheck
FROM
sierra_view.circ_trans C
WHERE
C.transaction_gmt >= NOW() - INTERVAL '1 month' AND C.op_code = 'r'
GROUP BY 1
ORDER BY 1