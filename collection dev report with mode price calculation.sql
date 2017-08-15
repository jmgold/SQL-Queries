--Calculates the cost per circ by itype at the network level.
--Provides this figure using both the avg. price and mode price for each itype, filtering out items with a price of $0 for these calculations
--Excludes items that do not circulate

SELECT
itype_code_num AS "itype",
COUNT(id) FILTER(WHERE location_code LIKE 'wel%') AS "Total_items",
SUM(checkout_total) FILTER(WHERE location_code LIKE 'wel%') AS "Total_Checkouts",
SUM(renewal_total) FILTER(WHERE location_code LIKE 'wel%') AS "Total_Renewals",
(SUM(checkout_total) FILTER(WHERE location_code LIKE 'wel%') + SUM(renewal_total) FILTER(WHERE location_code LIKE 'wel%'))AS "Total_Circulation",
ROUND(AVG(price) FILTER(WHERE price>'0' and price <'10000'),2) AS "AVG_Price",
ROUND(MODE() WITHIN GROUP (order by price) FILTER(WHERE price>'0' and price <'10000') ,2)AS "MODE_Price",
ROUND(MAX(price) FILTER(WHERE price<'10000'),2) AS "MAX_Price",
ROUND(MIN(price) FILTER(WHERE price>'0'),2) AS "MIN_Price",
ROUND((((COUNT(id) FILTER(WHERE location_code LIKE 'wel%'))*(AVG(price) FILTER(WHERE price>'0' and price <'10000')))/(NULLIF((SUM(checkout_total) FILTER(WHERE location_code LIKE 'wel%') + SUM(renewal_total) FILTER(WHERE location_code LIKE 'wel%')),0))),2) AS "Cost_Per_Circ_By_AVG_Price",
ROUND(((COUNT(id) FILTER(WHERE location_code LIKE 'wel%')*(MODE() WITHIN GROUP (order by price) FILTER(WHERE price>'0' and price <'10000')))/(NULLIF((SUM(checkout_total) FILTER(WHERE location_code LIKE 'wel%') + SUM(renewal_total) FILTER(WHERE location_code LIKE 'wel%')),0))),2) AS "Cost_Per_Circ_By_Mode_Price",
round(cast(SUM(checkout_total) FILTER(WHERE location_code LIKE 'wel%') + SUM(renewal_total) FILTER(WHERE location_code LIKE 'wel%') as numeric (12,2))/cast(count (id) FILTER(WHERE location_code LIKE 'wel%') as numeric (12,2)), 2) as turnover,
round(cast(count (*) as numeric (12,2)) / ((select cast(count (*)as numeric (12,2)) from sierra_view.item_view where location_code LIKE 'wel%')), 6) as relative_item_total,
round(cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2)) / ((select cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2)) from sierra_view.item_view WHERE location_code LIKE 'wel%')), 6) as relative_circ
FROM
sierra_view.item_record
--WHERE item_status_code != 'o' AND item_status_code != 'p' AND item_status_code != 'e' AND item_status_code != 'r'
group by 1