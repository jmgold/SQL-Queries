SELECT * FROM(
SELECT
--SUBSTRING(sg.name FROM 1 FOR 3) AS checkin_location,
it.name AS itype,
COUNT(t.id) AS total_checkins,
COUNT(t.id) FILTER (WHERE t.due_date_gmt::DATE - t.transaction_gmt::DATE > 1) AS returned_greater_than_1_day_early,
COUNT(t.id) FILTER (WHERE t.due_date_gmt::DATE - t.transaction_gmt::DATE = 1) AS returned_1_day_early,
COUNT(t.id) FILTER (WHERE t.due_date_gmt::DATE = t.transaction_gmt::DATE) AS returned_on_time,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE = 1) AS returned_1_day_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE BETWEEN 2 AND 7) AS returned_2_to_7_days_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE BETWEEN 8 AND 14) AS returned_8_to_14_days_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE BETWEEN 15 AND 21) AS returned_15_to_21_days_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE > 21) AS returned_greater_than_21_days_late
FROM
sierra_view.circ_trans t
/*JOIN
sierra_view.statistic_group_myuser sg
ON
t.stat_group_code_num = sg.code
*/
JOIN
sierra_view.itype_property_myuser it
ON
t.itype_code_num = it.code

WHERE
t.op_code = 'i'
AND t.transaction_gmt::DATE BETWEEN (CURRENT_DATE - INTERVAL '1 month') AND (CURRENT_DATE - INTERVAL '1 day')
AND t.stat_group_code_num::varchar ~ '^49[0-9]' 
GROUP BY 1

UNION

SELECT
--SUBSTRING(sg.name FROM 1 FOR 3) AS checkin_location,
'TOTAL' AS itype,
COUNT(t.id) AS total_checkins,
COUNT(t.id) FILTER (WHERE t.due_date_gmt::DATE - t.transaction_gmt::DATE = 1) AS returned_1_day_early,
COUNT(t.id) FILTER (WHERE t.due_date_gmt::DATE - t.transaction_gmt::DATE BETWEEN 2 AND 7) AS returned_2_to_7_days_early,
COUNT(t.id) FILTER (WHERE t.due_date_gmt::DATE = t.transaction_gmt::DATE) AS returned_on_time,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE = 1) AS returned_1_day_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE BETWEEN 2 AND 7) AS returned_2_to_7_days_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE BETWEEN 8 AND 14) AS returned_8_to_14_days_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE BETWEEN 15 AND 21) AS returned_15_to_21_days_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE > 21) AS returned_greater_than_21_days_late
FROM
sierra_view.circ_trans t
/*JOIN
sierra_view.statistic_group_myuser sg
ON
t.stat_group_code_num = sg.code
*/
JOIN
sierra_view.itype_property_myuser it
ON
t.itype_code_num = it.code

WHERE
t.op_code = 'i'
AND t.transaction_gmt::DATE BETWEEN (CURRENT_DATE - INTERVAL '1 month') AND (CURRENT_DATE - INTERVAL '1 day')
AND t.stat_group_code_num::varchar ~ '^49[0-9]' 
GROUP BY 1

)a

ORDER BY CASE
	WHEN itype = 'TOTAL' THEN 2
	ELSE 1
END,
itype