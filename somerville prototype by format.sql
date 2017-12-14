SELECT
CASE
WHEN b.material_code IN ('2', '9', 'a', 'c') THEN 'Books'
WHEN b.material_code IN ('4', 'i', 'z') THEN 'Audiobooks'
WHEN b.material_code IN ('5', 'g', 'u', 'x') THEN 'Video'
WHEN b.material_code = 'j' THEN 'CD'
ELSE 'Other'
END AS "Format",
COUNT (c.id) AS "Total_checkouts",
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
sierra_view.bib_record_property b
ON
c.bib_record_id = b.bib_record_id
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
Group by 1
;