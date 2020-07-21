SELECT
SUBSTRING(s.name,1,3),
o.due_gmt::DATE,
COUNT(o.id)

FROM
sierra_view.checkout o
JOIN
sierra_view.item_record i
ON
o.item_record_id = i.id
JOIN
sierra_view.statistic_group_myuser s
ON
i.checkout_statistic_group_code_num = s.code

WHERE o.due_gmt::DATE = '2020-07-31'
AND i.checkout_statistic_group_code_num BETWEEN '210' AND '299'

GROUP BY 1