SELECT
t.transaction_gmt,
to_char(t.transaction_gmt,'YYYY-MM-DD') AS "Date",
EXTRACT(HOUR FROM t.transaction_gmt)::INT AS "Hour",
CASE
	WHEN t.op_code = 'i' THEN 'Check In'
	WHEN t.op_code = 'o' THEN 'Check Out'
	WHEN t.op_code = 'f' THEN 'Filled Hold'
	WHEN t.op_code = 'r' THEN 'Renewal'
	ELSE 'Hold Placed'
END AS "Transaction Type",
CASE
	WHEN s.name IS NULL THEN t.stat_group_code_num::VARCHAR
	ELSE s.name
END AS "Stat Group",
SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,11) AS "GEOID",
COUNT(t.id) AS "Total"

FROM
sierra_view.circ_trans t
LEFT JOIN
sierra_view.statistic_group_myuser s
ON
t.stat_group_code_num = s.code
LEFT JOIN
sierra_view.varfield v
ON
v.record_id = t.patron_record_id AND v.varfield_type_code = 'k' AND v.field_content ~ '^\|s\d{2}'

WHERE
t.stat_group_code_num BETWEEN 300 AND 319

GROUP BY 1,2,3,4,5,6
ORDER BY 1,2,3,4,5,6