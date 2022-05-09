/*
Jeremy Goldstein
Minuteman Library Network

Rough equivalent to collection development report found in web management reports, organized by scat code and only utilizing item record data
See more comprehensive version of this report here https://github.com/Minuteman-Library-Network/SQL-Queries/blob/master/Custom%20reports%20site/collection%20development%20report.sql

location limit included in both the where clause and in relative_item_total and relative_circ statements
*/

SELECT
icode1 AS SCAT,
COUNT(*) AS Item_Total,
SUM(price)::MONEY AS price_total,
SUM(year_to_date_checkout_total) AS year_to_date_checkout_total,
SUM(renewal_total) AS renewal_total,
(SUM(checkout_total) + SUM(renewal_total)) AS circ_total,
ROUND(CAST(SUM(year_to_date_checkout_total) AS NUMERIC (12,2))/cast(count (*) AS numeric (12,2)), 2) AS turnover,
ROUND(CAST(count (*) AS numeric (12,2)) / ((SELECT CAST(COUNT (*) AS NUMERIC (12,2)) FROM sierra_view.item_view WHERE location_code LIKE 'nee%')), 6) AS relative_item_total,
ROUND(CAST(SUM(year_to_date_checkout_total) AS NUMERIC (12,2)) / ((SELECT CAST(SUM(year_to_date_checkout_total) AS NUMERIC (12,2)) FROM sierra_view.item_view WHERE location_code LIKE 'nee%')), 6) AS relative_circ,
COALESCE(SUM(price)::MONEY/NULLIF((SUM(year_to_date_checkout_total)),0),'$0.00') AS price_per_circ

FROM
sierra_view.item_record
WHERE
location_code LIKE 'nee%' -- and
--comment out date limit if unwanted
--cast(record_creation_date_gmt as date) between '2015-07-01' and '2016-06-30'
GROUP BY 1
ORDER BY 1, 2, 3, 4, 5, 6, 7, 8;
