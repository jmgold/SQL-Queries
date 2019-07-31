/*
Jeremy Goldstein
Minuteman Lirary Network
Gathers together various performance metrics for portions of a library's collection
Is passed variables for owning location, item status to exclude from the report, and the field to group the collection by
*/
SELECT
{{grouping}},
COUNT (i.id) AS "Item total",
SUM(i.checkout_total) AS "Total_Checkouts",
SUM(i.renewal_total) AS "Total_Renewals",
SUM(i.checkout_total) + SUM(i.renewal_total) AS "Total_Circulation",
ROUND(AVG(i.price) FILTER(WHERE i.price>'0' AND i.price <'10000'),2) AS "AVG_price",
COUNT(i.id) FILTER(WHERE c.id IS NOT NULL) AS "total_checked_out",
ROUND(CAST(COUNT(i.id) FILTER(WHERE c.id IS NOT NULL) AS NUMERIC (12,2)) / CAST(COUNT (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_checked_out",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS "have_circed_within_1_year",
ROUND(CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS NUMERIC (12,2)) / CAST(COUNT (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_1_year",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS "have_circed_within_3_years",
ROUND(CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS NUMERIC (12,2)) / CAST(COUNT (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_3_years",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS "have_circed_within_5_years",
ROUND(CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS NUMERIC (12,2)) / CAST(COUNT (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_5_years",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt is not null) AS "have_circed_within_5+_years",
ROUND(CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt is not null) AS NUMERIC (12,2)) / CAST(COUNT (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_5+_years",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt is null) AS "0_circs",
ROUND(CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt is null) AS NUMERIC (12,2)) / CAST(COUNT (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_0_circs",
ROUND((COUNT(i.id) *(AVG(i.price) FILTER(WHERE i.price>'0' AND i.price <'10000'))/(NULLIF((SUM(i.checkout_total) + SUM(i.renewal_total)),0))),2) AS "Cost_Per_Circ_By_AVG_price",
round(cast(SUM(i.checkout_total) + SUM(i.renewal_total) as numeric (12,2))/cast(COUNT (i.id) as numeric (12,2)), 2) as turnover,
round(cast(COUNT(i.id) as numeric (12,2)) / (select cast(COUNT (i.id) as numeric (12,2))from sierra_view.item_record i WHERE i.location_code ~ {{Location}} AND i.item_status_code not in ({{Item_Status_Codes}})), 6) as relative_item_total,
round(cast(SUM(i.checkout_total) + SUM(i.renewal_total) as numeric (12,2)) / (SELECT cast(SUM(i.checkout_total) + SUM(i.renewal_total) as numeric (12,2)) from sierra_view.item_record i WHERE i.location_code ~ {{Location}} AND i.item_status_code NOT IN ({{Item_Status_Codes}})), 6) as relative_circ
FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN sierra_view.bib_record b
ON
l.bib_record_id = b.id
LEFT JOIN
sierra_view.checkout c
ON
i.id = c.item_record_id
JOIN
sierra_view.material_property mp
ON
b.bcode2 = mp.code
JOIN
sierra_view.material_property_name m
ON 
mp.id = m.material_property_id
JOIN
sierra_view.itype_property ip
ON
i.itype_code_num = ip.code_num
JOIN
sierra_view.itype_property_name it
ON 
ip.id = it.itype_property_id
JOIN
sierra_view.language_property lp
ON
b.language_code = lp.code
JOIN
sierra_view.language_property_name ln
ON
lp.id = LN.language_property_id
WHERE location_code ~ {{Location}} and item_status_code not IN ({{Item_Status_Codes}})
GROUP BY 1
ORDER BY 1;
