SELECT
t.transaction_gmt::DATE AS "Date",
TO_CHAR(transaction_gmt::DATE,'Day') AS "Day",
CASE
	WHEN t.op_code = 'i' THEN 'Check In'
	WHEN t.op_code = 'o' THEN 'Check Out'
	WHEN t.op_code = 'f' THEN 'Filled hold'
END AS "Transaction Type",
t.stat_group_code_num AS "Stat Group",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=0) AS "0",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=1) AS "1",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=2) AS "2",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=3) AS "3",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=4) AS "4",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=5) AS "5",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=6) AS "6",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=7) AS "7",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=8) AS "8",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=9) AS "9",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=10) AS "10",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=11) AS "11",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=12) AS "12",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=13) AS "13",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=14) AS "14",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=15) AS "15",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=16) AS "16",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=17) AS "17",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=18) AS "18",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=19) AS "19",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=20) AS "20",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=21) AS "21",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=21) AS "22",
COUNT(t.id) FILTER(WHERE EXTRACT(HOUR FROM t.transaction_gmt)=21) AS "23"
FROM
sierra_view.circ_trans t
WHERE t.op_code IN ('o','i','f')
AND t.stat_group_code_num BETWEEN 570 AND 579
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4
