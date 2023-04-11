/*
Jeremy Goldstein
Minuteman Library Network

Checks if autonotices ran, based on the presence of triggered autorenewals
*/

SELECT
CASE
	WHEN COUNT(t.id) = 0 THEN FALSE
	ELSE TRUE
END AS notices_ran

FROM
sierra_view.circ_trans t

WHERE
t.op_code = 'r' AND t.application_name = 'autonotices'
AND t.transaction_gmt::DATE = CURRENT_DATE
