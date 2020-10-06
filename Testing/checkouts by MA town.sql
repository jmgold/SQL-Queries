SELECT
p3.name||', MA' AS ma_town,
l.name AS checkout_location,
COUNT(t.id) AS checkout_total

FROM
sierra_view.circ_trans t
JOIN
sierra_view.patron_record p
ON
t.patron_record_id = p.id AND t.op_code = 'o'
JOIN
sierra_view.user_defined_pcode3_myuser p3
ON
p.pcode3::varchar = p3.code
JOIN
sierra_view.statistic_group_myuser S
ON
t.stat_group_code_num = S.code
JOIN
sierra_view.location_myuser l
ON
S.location_code = l.code

--WHERE
--t.transaction_gmt::DATE >= current_date

GROUP BY 2,1
ORDER BY 2,3 DESC