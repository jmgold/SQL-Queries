SELECT
language_property_myuser.name AS "language",
COUNT (i.id) AS "Item total",
SUM(i.checkout_total) AS "Total_Checkouts",
SUM(i.renewal_total) AS "Total_Renewals",
SUM(i.checkout_total) + SUM(i.renewal_total) AS "Total_Circulation",
ROUND(AVG(i.price) FILTER(WHERE i.price>'0' and i.price <'10000'),2) AS "AVG_price",
--COUNT (id) FILTER(WHERE last_checkout_gmt >= (localtimestamp - interval '1 month')) AS "1 month",
--ROUND(CAST(COUNT(id) FILTER(WHERE last_checkout_gmt >= (localtimestamp - interval '1 month')) AS NUMERIC (12,2)) / CAST(count (id) AS NUMERIC (12,2)), 6) AS "Percentage_1 month",
--COUNT (id) FILTER(WHERE (last_checkout_gmt < (localtimestamp - interval '1 months')) AND (last_checkout_gmt >= (localtimestamp - interval '3 months'))) AS "3 months",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS "have_circed_within_1_year",
ROUND(CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS NUMERIC (12,2)) / CAST(count (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_1_year",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS "have_circed_within_3_years",
ROUND(CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS NUMERIC (12,2)) / CAST(count (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_3_years",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS "have_circed_within_5_years",
ROUND(CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS NUMERIC (12,2)) / CAST(count (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_5_years",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt is not null) AS "have_circed_within_5+_years",
ROUND(CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt is not null) AS NUMERIC (12,2)) / CAST(count (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_5+_years",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt is null) AS "0_circs",
ROUND(CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt is null) AS NUMERIC (12,2)) / CAST(count (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_0_circs",
ROUND((COUNT(i.id) *(AVG(i.price) FILTER(WHERE i.price>'0' and i.price <'10000'))/(NULLIF((SUM(i.checkout_total) + SUM(i.renewal_total)),0))),2) AS "Cost_Per_Circ_By_AVG_price",
round(cast(SUM(i.checkout_total) + SUM(i.renewal_total) as numeric (12,2))/cast(count (i.id) as numeric (12,2)), 2) as turnover,
round(cast(count(i.id) as numeric (12,2)) / (select cast(count (id) as numeric (12,2))from sierra_view.item_record where item_status_code not in ('o', 'n', '$', 'w', 'z', 'd', 'e')), 6) as relative_item_total,
round(cast(SUM(i.checkout_total) + SUM(i.renewal_total) as numeric (12,2)) / (SELECT cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2)) from sierra_view.item_record where item_status_code not in ('o', 'n', '$', 'w', 'z', 'd', 'e')), 6) as relative_circ
FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link
ON
i.id = bib_record_item_record_link.item_record_id
JOIN
sierra_view.bib_record
ON
bib_record_item_record_link.bib_record_id = bib_record.id
JOIN
sierra_view.language_property_myuser
ON
language_property_myuser.code = bib_record.language_code
WHERE i.item_status_code not in ('o', 'n', '$', 'w', 'z', 'd', 'e')
GROUP BY 1
ORDER BY 2 desc;
