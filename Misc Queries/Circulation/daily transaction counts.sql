/*
Jeremy Goldstein
Minuteman Library Network
Captures daily transaction counts by each transaction type
*/

SELECT
t.transaction_gmt::DATE AS "date"
,COUNT(t.id) FILTER(WHERE t.op_code = 'o') AS checkouts
,COUNT(t.id) FILTER(WHERE t.op_code = 'i') AS checkins
,COUNT(t.id) FILTER(WHERE t.op_code = 'r') AS renewals
,COUNT(t.id) FILTER(WHERE t.op_code = 'f') AS filled_holds
,COUNT(t.id) FILTER(WHERE t.op_code ~ 'n|h') AS holds_placed
,COUNT(t.id) FILTER(WHERE t.op_code = 'u') AS use_count
,COUNT(t.id) FILTER(WHERE t.op_code = 'b') AS bookings

FROM
sierra_view.circ_trans t

GROUP BY 1
ORDER BY 1