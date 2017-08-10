SELECT
--b.bcode2 AS "Mat_type",
i.itype_code_num AS "itype",
COUNT(i.id) AS "Total_items",
SUM(i.checkout_total) AS "Total_Checkouts",
AVG(i.price) AS "AVG_Price",
MODE() WITHIN GROUP (order by i.price) AS "MODE_Price",
MAX(i.price) AS "MAX_Price",
MIN(i.price) AS "MIN_Price",
((COUNT(i.id)*MODE() WITHIN GROUP (order by i.price))/(NULLIF(SUM(i.checkout_total),0))) AS "Cost_Per_Circ_By_Mode_Price",
((COUNT(i.id)*AVG(i.price))/(NULLIF(SUM(i.checkout_total),0))) AS "Cost_Per_Circ_By_AVG_Price"
FROM
--sierra_view.bib_view b
--JOIN
--sierra_view.bib_record_item_record_link bi
--ON
--bi.bib_record_id=b.id
--JOIN
sierra_view.item_record i
--ON
--bi.item_record_id=i.id 
WHERE i.item_status_code != 'o' AND i.item_status_code != 'p' AND i.item_status_code != 'e' AND i.item_status_code != 'r'
group by 1