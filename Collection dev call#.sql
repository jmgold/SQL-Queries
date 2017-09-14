SELECT
CASE
WHEN v.field_content ~ '\|a0[0-9][0-9]' THEN '000'
WHEN v.field_content ~ '\|a1[0-9][0-9]' THEN '100'
WHEN v.field_content ~ '\|a2[0-9][0-9]' THEN '200'
WHEN v.field_content ~ '\|a3[0-9][0-9]' THEN '300'
WHEN v.field_content ~ '\|a4[0-9][0-9]' THEN '400'
WHEN v.field_content ~ '\|a5[0-9][0-9]' THEN '500'
WHEN v.field_content ~ '\|a6[0-9][0-9]' THEN '600'
WHEN v.field_content ~ '\|a7[0-9][0-9]' THEN '700'
WHEN v.field_content ~ '\|a8[0-9][0-9]' THEN '800'
WHEN v.field_content ~ '\|a9[0-9][0-9]' THEN '900'
ELSE 'unknown'
END AS "Call#_Range",
COUNT (i.id) AS "Item total",
SUM(i.checkout_total) AS "Total_Checkouts",
SUM(i.renewal_total) AS "Total_Renewals",
SUM(i.checkout_total) + SUM(i.renewal_total) AS "Total_Circulation",
ROUND(AVG(i.price) FILTER(WHERE i.price>'0' and i.price <'10000'),2) AS "AVG_price",
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
round(cast(count(i.id) as numeric (12,2)) / (select cast(count (id) as numeric (12,2))from sierra_view.item_record where location_code LIKE 'brk%'), 6) as relative_item_total,
round(cast(SUM(i.checkout_total) + SUM(i.renewal_total) as numeric (12,2)) / (SELECT cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2)) from sierra_view.item_record where location_code LIKE 'brk%'), 6) as relative_circ
FROM
sierra_view.item_record as i
JOIN
sierra_view.varfield as v
ON
v.record_id = i.id AND v.varfield_type_code = 'c'
WHERE i.location_code LIKE 'brk%'
GROUP BY 1
ORDER BY 1;