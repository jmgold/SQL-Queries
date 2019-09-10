SELECT
CASE
	WHEN i.call_number_norm = '' OR i.call_number_norm IS NULL THEN 'no call number'
	WHEN i.call_number_norm !~ '\d' AND REVERSE(i.call_number_norm) ~ '^[a-z\.]+\s?,[a-z]' THEN REVERSE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)),'^\w+\s?,?\w+', ''))
	WHEN i.call_number_norm !~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)),'^\w*\s', ''))
	WHEN TRIM(BOTH FROM i.call_number_norm) ~ '^[0-9]' THEN SUBSTRING(TRIM(BOTH FROM i.call_number_norm),'^[0-9]{2}')||'0'
	WHEN REVERSE(TRIM(BOTH FROM i.call_number_norm)) ~ '^[0-9]{3}[12]' THEN REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)),'^[0-9]{3}[12]',''),'^\w*\s', ''))
	WHEN TRIM(BOTH FROM i.call_number_norm) ~ '\[0-9]\s\w+$' THEN REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)),'^\w*\s', ''),'^\w*\s', ''))
	ELSE 'unknown'
END AS call_number_range,
COUNT (ir.id) AS "Item total",
SUM(ir.checkout_total) AS "Total_Checkouts",
SUM(ir.renewal_total) AS "Total_Renewals",
SUM(ir.checkout_total) + SUM(ir.renewal_total) AS "Total_Circulation",
ROUND(AVG(ir.price) FILTER(WHERE ir.price>'0' and ir.price <'10000'),2) AS "AVG_price",
COUNT (ir.id) FILTER(WHERE ir.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS "have_circed_within_1_year",
ROUND(CAST(COUNT(ir.id) FILTER(WHERE ir.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS NUMERIC (12,2)) / CAST(count (ir.id) AS NUMERIC (12,2)), 6) AS "Percentage_1_year",
COUNT (ir.id) FILTER(WHERE ir.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS "have_circed_within_3_years",
ROUND(CAST(COUNT(ir.id) FILTER(WHERE ir.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS NUMERIC (12,2)) / CAST(count (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_3_years",
COUNT (ir.id) FILTER(WHERE ir.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS "have_circed_within_5_years",
ROUND(CAST(COUNT(ir.id) FILTER(WHERE ir.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS NUMERIC (12,2)) / CAST(count (ir.id) AS NUMERIC (12,2)), 6) AS "Percentage_5_years",
COUNT (ir.id) FILTER(WHERE ir.last_checkout_gmt is not null) AS "have_circed_within_5+_years",
ROUND(CAST(COUNT(ir.id) FILTER(WHERE ir.last_checkout_gmt is not null) AS NUMERIC (12,2)) / CAST(count (ir.id) AS NUMERIC (12,2)), 6) AS "Percentage_5+_years",
COUNT (ir.id) FILTER(WHERE ir.last_checkout_gmt is null) AS "0_circs",
ROUND(CAST(COUNT(ir.id) FILTER(WHERE ir.last_checkout_gmt is null) AS NUMERIC (12,2)) / CAST(count (ir.id) AS NUMERIC (12,2)), 6) AS "Percentage_0_circs",
ROUND((COUNT(ir.id) *(AVG(ir.price) FILTER(WHERE ir.price>'0' and ir.price <'10000'))/(NULLIF((SUM(ir.checkout_total) + SUM(ir.renewal_total)),0))),2) AS "Cost_Per_Circ_By_AVG_price",
round(cast(SUM(ir.checkout_total) + SUM(ir.renewal_total) as numeric (12,2))/cast(count (ir.id) as numeric (12,2)), 2) as turnover,
round(cast(count(ir.id) as numeric (12,2)) / (select cast(count (id) as numeric (12,2))from sierra_view.item_record where location_code LIKE 'arl%' and item_status_code not in ('o', 'n', '$', 'w', 'z', 'd', 'e')), 6) as relative_item_total,
round(cast(SUM(ir.checkout_total) + SUM(ir.renewal_total) as numeric (12,2)) / (SELECT cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2)) from sierra_view.item_record where location_code LIKE 'arl%' and item_status_code not in ('o', 'n', '$', 'w', 'z', 'd', 'e')), 6) as relative_circ

FROM
sierra_view.item_record_property i
JOIN
sierra_view.item_record ir
ON
i.item_record_id = ir.id
AND
ir.location_code ~ '^brk'
/*JOIN
sierra_view.bib_record_item_record_link l
ON
ir.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
*/
GROUP BY 1
ORDER BY 1;