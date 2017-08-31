SELECT
icode1 AS "Scat",
COUNT (id) AS "Item total",

SUM(checkout_total) AS "Total_Checkouts",
SUM(renewal_total) AS "Total_Renewals",
SUM(checkout_total) + SUM(renewal_total) AS "Total_Circulation",
ROUND(AVG(price) FILTER(WHERE price>'0' and price <'10000'),2) AS "AVG_price",
--COUNT (id) FILTER(WHERE last_checkout_gmt >= (localtimestamp - interval '1 month')) AS "1 month",
--ROUND(CAST(COUNT(id) FILTER(WHERE last_checkout_gmt >= (localtimestamp - interval '1 month')) AS NUMERIC (12,2)) / CAST(count (id) AS NUMERIC (12,2)), 6) AS "Percentage_1 month",
--COUNT (id) FILTER(WHERE (last_checkout_gmt < (localtimestamp - interval '1 months')) AND (last_checkout_gmt >= (localtimestamp - interval '3 months'))) AS "3 months",
COUNT (id) FILTER(WHERE last_checkout_gmt >= (localtimestamp - interval '1 year')) AS "have_circed_within_1_year",
ROUND(CAST(COUNT(id) FILTER(WHERE last_checkout_gmt >= (localtimestamp - interval '1 year')) AS NUMERIC (12,2)) / CAST(count (id) AS NUMERIC (12,2)), 6) AS "Percentage_1_year",
COUNT (id) FILTER(WHERE last_checkout_gmt >= (localtimestamp - interval '3 years')) AS "have_circed_within_3_years",
ROUND(CAST(COUNT(id) FILTER(WHERE last_checkout_gmt >= (localtimestamp - interval '3 years')) AS NUMERIC (12,2)) / CAST(count (id) AS NUMERIC (12,2)), 6) AS "Percentage_3_years",
COUNT (id) FILTER(WHERE last_checkout_gmt >= (localtimestamp - interval '5 years')) AS "have_circed_within_5_years",
ROUND(CAST(COUNT(id) FILTER(WHERE last_checkout_gmt >= (localtimestamp - interval '5 years')) AS NUMERIC (12,2)) / CAST(count (id) AS NUMERIC (12,2)), 6) AS "Percentage_5_years",
COUNT (id) FILTER(WHERE last_checkout_gmt < (localtimestamp - interval '5 years')) AS "have_circed_within_5+_years",
ROUND(CAST(COUNT(id) FILTER(WHERE last_checkout_gmt >= (localtimestamp - interval '5 years')) AS NUMERIC (12,2)) / CAST(count (id) AS NUMERIC (12,2)), 6) AS "Percentage_5+_years",
COUNT (id) FILTER(WHERE last_checkout_gmt is null) AS "0_circs",
ROUND(CAST(COUNT(id) FILTER(WHERE last_checkout_gmt is null) AS NUMERIC (12,2)) / CAST(count (id) AS NUMERIC (12,2)), 6) AS "Percentage_0_circs",
ROUND((COUNT(id) *(AVG(price) FILTER(WHERE price>'0' and price <'10000'))/(NULLIF((SUM(checkout_total) + SUM(renewal_total)),0))),2) AS "Cost_Per_Circ_By_AVG_price",
round(cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2))/cast(count (id) as numeric (12,2)), 2) as turnover,
round(cast(count(id) as numeric (12,2)) / (select cast(count (id) as numeric (12,2))from sierra_view.item_record where location_code LIKE 'ntn%'), 6) as relative_item_total,
round(cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2)) / (SELECT cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2)) from sierra_view.item_record where location_code LIKE 'ntn%'), 6) as relative_circ
FROM
sierra_view.item_record
WHERE location_code LIKE 'ntn%'
GROUP BY 1
ORDER BY 1;
