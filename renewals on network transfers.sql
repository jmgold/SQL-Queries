SELECT  
  c.stat_group_code_num,
  c.item_location_code,
  count(c.id)  
FROM 
  sierra_view.circ_trans c
JOIN
  sierra_view.statistic_group s
  ON
  c.stat_group_code_num = s.code_num
WHERE 
  c.transaction_gmt >= '171020 00:00:00' AND 
  c.transaction_gmt <= '171102 24:00:00' AND
  c.op_code = 'r' AND
  c.item_location_code NOT LIKE (s.location_code || '%')
Group By
  1,2
  
Order by

1, 2 asc;