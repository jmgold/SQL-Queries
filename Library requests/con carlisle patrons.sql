SELECT
COUNT(DISTINCT t.patron_record_id)
FROM
sierra_view.circ_trans t
JOIN
sierra_view.patron_record_address p
ON
t.patron_record_id = p.patron_record_id
AND p.postal_code = '01741'
AND t.stat_group_code_num BETWEEN '300' AND '319'
AND t.op_code IN ('o','i','r')