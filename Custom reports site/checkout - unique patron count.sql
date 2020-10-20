/*
Jeremy Goldstein
Minuteman Library Network

Monthly checkouts with unique patron count

Takes variables for transaction location and unit of time to group the report by

*/

SELECT * FROM
(
SELECT
CASE
WHEN {{time_unit}} = 'date' THEN to_char(c.transaction_gmt, 'MM-DD-YY')
WHEN {{time_unit}} = 'hour' THEN to_char(c.transaction_gmt, 'HH24')
WHEN {{time_unit}} = 'dow' THEN 
--time_unit values are date, hour, dow
CASE
WHEN EXTRACT (DOW from c.transaction_gmt) = '0' THEN 'Sunday'
WHEN EXTRACT (DOW from c.transaction_gmt) = '1' THEN 'Monday'
WHEN EXTRACT (DOW from c.transaction_gmt) = '2' THEN 'Tuesday'
WHEN EXTRACT (DOW from c.transaction_gmt) = '3' THEN 'Wednesday'
WHEN EXTRACT (DOW from c.transaction_gmt) = '4' THEN 'Thursday'
WHEN EXTRACT (DOW from c.transaction_gmt) = '5' THEN 'Friday'
Else 'Saturday'
END
END AS transaction_time,
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
and s.location_code ~ {{location}}
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
GROUP BY 1
)a
ORDER BY
CASE WHEN transaction_time = 'Sunday' THEN '0'
WHEN transaction_time = 'Monday' THEN '1'
WHEN transaction_time = 'Tuesday' THEN '2'
WHEN transaction_time = 'Wednesday' THEN '3'
WHEN transaction_time = 'Thursday' THEN '4'
WHEN transaction_time = 'Friday' THEN '5'
WHEN transaction_time = 'Satday' THEN '0'
ELSE transaction_time
END