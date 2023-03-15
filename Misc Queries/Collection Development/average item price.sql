/*
Jeremy Goldstein
Minuteman Library network

Calculates the cost per circ by itype at the network level.
Provides this figure using both the avg. price and mode price for each itype, filtering out items with a price of $0 for these calculations
Excludes items that do not circulate
*/

SELECT
i.itype_code_num AS itype,
COUNT(i.id) AS Total_items,
SUM(i.checkout_total) AS Total_Checkouts,
AVG(i.price) FILTER(WHERE i.price>'0' and i.price <'1000000')::MONEY AS AVG_Price,
MODE() WITHIN GROUP (order by i.price) FILTER(WHERE i.price>'0' and i.price <'1000000')::MONEY AS MODE_Price,
MAX(i.price) FILTER(WHERE i.price<'1000000')::MONEY AS MAX_Price,
MIN(i.price) FILTER(WHERE i.price>'0')::MONEY AS MIN_Price,
((COUNT(i.id)*(AVG(i.price) FILTER(WHERE i.price>'0' and i.price <'1000000')))/(NULLIF(SUM(i.checkout_total),0)))::MONEY AS Cost_Per_Circ_By_AVG_Price,
((COUNT(i.id)*(MODE() WITHIN GROUP (order by i.price) FILTER(WHERE i.price>'0' and i.price <'1000000')))/(NULLIF(SUM(i.checkout_total),0)))::MONEY AS Cost_Per_Circ_By_Mode_Price

FROM
sierra_view.item_record i
 
WHERE i.item_status_code NOT IN ('o','p','e','r')
GROUP BY 1