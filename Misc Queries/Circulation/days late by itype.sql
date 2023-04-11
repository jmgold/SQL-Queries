/*
Jeremy Goldstein
Minuteman Library Network

Calculates how many items the number of days past the due date each item is returned
and groups results by itype and the number of days

Filtered to a single transaction location based on stat group range
*/

SELECT
i.itype_code_num,
ip.name AS itype_name,
c.transaction_gmt::DATE - c.due_date_gmt::date AS days_late,
COUNT(c.id) AS item_count

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

GROUP BY 1,2,3
ORDER BY 1,3