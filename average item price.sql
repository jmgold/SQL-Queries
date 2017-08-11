--Calculates the cost per circ by itype at the network level.
--Provides this figure using both the avg. price and mode price for each itype, filtering out items with a price of $0 for these calculations
--Excludes items that do not circulate

--includes commented out code to allow easy grouping by mattype instead of itype if desired

SELECT
--b.bcode2 AS "Mat_type",
i.itype_code_num AS "itype",
COUNT(i.id) AS "Total_items",
SUM(i.checkout_total) AS "Total_Checkouts",
AVG(i.price) FILTER(WHERE i.price>'0') AS "AVG_Price",
MODE() WITHIN GROUP (order by i.price) FILTER(WHERE i.price>'0') AS "MODE_Price",
MAX(i.price) AS "MAX_Price",
MIN(i.price) AS "MIN_Price",
((COUNT(i.id)*(AVG(i.price) FILTER(WHERE i.price>'0')))/(NULLIF(SUM(i.checkout_total),0))) AS "Cost_Per_Circ_By_AVG_Price",
((COUNT(i.id)*(MODE() WITHIN GROUP (order by i.price) FILTER(WHERE i.price>'0')))/(NULLIF(SUM(i.checkout_total),0))) AS "Cost_Per_Circ_By_Mode_Price"

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