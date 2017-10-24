SELECT
COUNT(c.id) AS "total_checkout",
COUNT(c.id) FILTER(WHERE i.location_code LIKE 'so%') AS "total_SOM_items",
COUNT(c.id) FILTER(WHERE i.location_code NOT LIKE 'so%') AS "total_ILL_items",
COUNT(c.id) FILTER(WHERE c.stat_group_code_num BETWEEN '640' AND '648') AS "Checkout_count_main",
COUNT(c.id) FILTER(WHERE c.stat_group_code_num BETWEEN '650' AND '658') AS "Checkout_count_east",
COUNT(c.id) FILTER(WHERE c.stat_group_code_num BETWEEN '660' AND '668') AS "Checkout_count_west",
COUNT(DISTINCT p.id) AS "Total_Unique_patrons",
COUNT(DISTINCT p.id) FILTER(WHERE c.stat_group_code_num BETWEEN '640' AND '648') AS "Main_Unique_patrons",
COUNT(DISTINCT p.id) FILTER(WHERE c.stat_group_code_num BETWEEN '650' AND '658') AS "East_Unique_patrons",
COUNT(DISTINCT p.id) FILTER(WHERE c.stat_group_code_num BETWEEN '660' AND '668') AS "West_Unique_patrons",
SUM(i.price) AS "Total_value_of_items",
SUM(i.price) / COUNT(DISTINCT p.id) AS "avg_value_Per_patron"
FROM
sierra_view.circ_trans c
JOIN
sierra_view.patron_record p
ON
c.patron_record_id=p.id
JOIN
sierra_view.item_record i
ON
c.item_record_id=i.id
WHERE
c.stat_group_code_num BETWEEN '640' AND '668'
AND
c.op_code = 'o'
AND
c.transaction_gmt > (current_date - 1)
;

