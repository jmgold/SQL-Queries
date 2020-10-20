/*
Jeremy Goldstein
Minuteman Library Network

Counts renewals each day for the past month by their source
*/

SELECT
C.transaction_gmt::DATE AS "date",
COUNT(C.id) AS total_renewals,
COUNT(C.id) FILTER(WHERE c.application_name = 'autonotices') AS total_autorenewals,
COUNT(C.id) FILTER(WHERE c.application_name = 'webpac') AS total_online_renewals,
COUNT(C.id) FILTER(WHERE c.application_name = 'sierra') AS total_sierra,
COUNT(C.id) FILTER(WHERE c.application_name IN ('selfcheck','milmyselfcheck')) AS total_selfcheck
FROM
sierra_view.circ_trans C
WHERE
C.transaction_gmt >= NOW() - INTERVAL '1 month' AND C.op_code = 'r'
AND C.item_location_code ~ {{location}}
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
GROUP BY 1
ORDER BY 1