SELECT
it.name AS item_type,
COUNT(o.item_record_id) AS total_checkouts,
COUNT(o.item_record_id) FILTER (WHERE o.due_gmt::DATE >= CURRENT_DATE) AS count_on_time,
COUNT(o.item_record_id) FILTER (WHERE o.due_gmt::DATE < CURRENT_DATE) AS count_overdue,
ROUND((COUNT(o.item_record_id) FILTER (WHERE o.due_gmt::DATE < CURRENT_DATE)*1.00)/(COUNT(o.item_record_id)*1.00) * 100,2) AS pct_overdue

FROM
sierra_view.checkout o
JOIN
sierra_view.item_record i
ON
o.item_record_id = i.id
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code

WHERE
o.loanrule_code_num BETWEEN 321 AND 331 OR o.loanrule_code_num BETWEEN 762 AND 770

GROUP BY 1
ORDER BY 1