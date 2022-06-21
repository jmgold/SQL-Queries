/*
Jeremy Goldstein
Minuteman Library Network

Counts daily renewals on items that were not checked out by the owning library
*/

SELECT
c.transaction_gmt::DATE AS renewal_date,  
c.stat_group_code_num,
sg.name AS stat_group_label,
COUNT(c.id) AS renewal_total
  
FROM 
sierra_view.circ_trans c
JOIN
sierra_view.statistic_group s
ON
c.stat_group_code_num = s.code_num
JOIN
sierra_view.statistic_group_myuser sg
ON
s.code_num = sg.code
WHERE 
c.op_code = 'r' AND
c.item_location_code NOT LIKE (s.location_code || '%')

GROUP BY 1,2,3
ORDER BY 1,2