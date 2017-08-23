--Calculates the cost per circ by itype at the network level.
--Provides this figure using both the avg. i.price and mode i.price for each itype, filtering out items with a i.price of $0 for these calculations
--Excludes items that do not circulate

SELECT
i.itype_code_num AS "itype_code",
it.name AS "itype_label",
COUNT(i.id) FILTER(WHERE i.location_code LIKE 'fpl%') AS "Total_items",
SUM(i.checkout_total) FILTER(WHERE i.location_code LIKE 'fpl%') AS "Total_Checkouts",
SUM(i.renewal_total) FILTER(WHERE i.location_code LIKE 'fpl%') AS "Total_Renewals",
(SUM(i.checkout_total) FILTER(WHERE i.location_code LIKE 'fpl%') + SUM(i.renewal_total) FILTER(WHERE i.location_code LIKE 'fpl%'))AS "Total_Circulation",
ROUND(AVG(i.price) FILTER(WHERE i.price>'0' and i.price <'10000'),2) AS "AVG_i.price",
ROUND(MODE() WITHIN GROUP (order by i.price) FILTER(WHERE i.price>'0' and i.price <'10000') ,2)AS "MODE_i.price",
ROUND(MAX(i.price) FILTER(WHERE i.price<'10000'),2) AS "MAX_i.price",
ROUND(MIN(i.price) FILTER(WHERE i.price>'0'),2) AS "MIN_i.price",
ROUND((((COUNT(i.id) FILTER(WHERE i.location_code LIKE 'fpl%'))*(AVG(i.price) FILTER(WHERE i.price>'0' and i.price <'10000')))/(NULLIF((SUM(i.checkout_total) FILTER(WHERE i.location_code LIKE 'fpl%') + SUM(i.renewal_total) FILTER(WHERE i.location_code LIKE 'fpl%')),0))),2) AS "Cost_Per_Circ_By_AVG_price",
ROUND(((COUNT(i.id) FILTER(WHERE i.location_code LIKE 'fpl%')*(MODE() WITHIN GROUP (order by i.price) FILTER(WHERE i.price>'0' and i.price <'10000')))/(NULLIF((SUM(i.checkout_total) FILTER(WHERE i.location_code LIKE 'fpl%') + SUM(i.renewal_total) FILTER(WHERE i.location_code LIKE 'fpl%')),0))),2) AS "Cost_Per_Circ_By_Mode_price",
round(cast(SUM(i.checkout_total) FILTER(WHERE i.location_code LIKE 'fpl%') + SUM(i.renewal_total) FILTER(WHERE i.location_code LIKE 'fpl%') as numeric (12,2))/cast(count (i.id) FILTER(WHERE i.location_code LIKE 'fpl%') as numeric (12,2)), 2) as turnover,
round(cast(count(i.id) FILTER(WHERE i.location_code LIKE 'fpl%') as numeric (12,2)) / ((select cast(count (*)as numeric (12,2)) from sierra_view.item_view i where i.location_code LIKE 'fpl%')), 6) as relative_item_total,
round(cast(SUM(i.checkout_total) FILTER(WHERE i.location_code LIKE 'fpl%') + SUM(i.renewal_total) FILTER(WHERE i.location_code LIKE 'fpl%') as numeric (12,2)) / ((select cast(SUM(i.checkout_total) + SUM(i.renewal_total) as numeric (12,2)) from sierra_view.item_view i WHERE i.location_code LIKE 'fpl%')), 6) as relative_circ
FROM
sierra_view.item_record i
JOIN
sierra_view.itype_property_myuser it
ON
it.code = i.itype_code_num
--WHERE item_status_code != 'o' AND item_status_code != 'p' AND item_status_code != 'e' AND item_status_code != 'r'
group by 1, 2