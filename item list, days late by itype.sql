SELECT
i.itype_code_num,
ip.name AS itype_name,
c.transaction_gmt AS checkin_date,
EXTRACT(EPOCH FROM DATE_TRUNC('day', AGE(c.transaction_gmt::date,c.due_date_gmt::date)))/86400 as days_late

FROM
sierra_view.circ_trans c
JOIN
sierra_view.item_record i
ON
c.item_record_id = i.id
JOIN
sierra_view.itype_property_myuser ip
ON
i.itype_code_num = ip.code

WHERE
c.op_code = 'i' 
AND c.stat_group_code_num BETWEEN '110' AND '129'
AND c.due_date_gmt < c.transaction_gmt

ORDER BY 1,3