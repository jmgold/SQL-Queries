SELECT
CASE
	WHEN p3.name IN ('-', 'Out of state', 'ComCat', 'ILL', 'Other MA') THEN ''
	WHEN p3.name = 'Fram. State' THEN 'Framingham MA'
	WHEN p3.name = 'Dean College' THEN 'Franklin MA'
	WHEN p3.name = 'Lasell University' THEN 'Newton MA'
	WHEN p3.name = 'Olin College' THEN 'Needham MA'
	WHEN p3.name = 'Regis College' THEN 'Weston MA'	
	WHEN p3.name = 'Pine Manor College' THEN 'Newton MA'
	ELSE p3.name||' MA'
END AS ma_town,
COALESCE(SUBSTRING(a.postal_code,1,5),'') AS zip,
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
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id

--WHERE
--t.transaction_gmt::DATE >= current_date

GROUP BY 3,1,2
ORDER BY 3,4 DESC