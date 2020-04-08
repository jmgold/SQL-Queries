
/*
Jeremy Goldstein
Minuteman Lirary Network
Gathers together various performance metrics for portions of a library's collection
Is passed variables for owning location, item status to exclude from the report, and the field to group the collection by
*/

WITH call_number_mod AS(
SELECT
i.item_record_id,
CASE
	WHEN b.best_author_norm != '' AND i.call_number_norm ~ ('^.+'||SPLIT_PART(b.best_author_norm, ' ',1)) THEN SPLIT_PART(i.call_number_norm,SPLIT_PART(b.best_author_norm, ' ',1),1)
	WHEN i.call_number_norm ~ ('^.+'||SPLIT_PART(REGEXP_REPLACE(b.best_title_norm,'\*|\+|\?|\{',''), ' ',1)) THEN SPLIT_PART(i.call_number_norm,SPLIT_PART(b.best_title_norm, ' ',1),1)
	ELSE i.call_number_norm
	END AS call_number_norm

FROM
sierra_view.item_record_property i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.item_record_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
)

SELECT
{{grouping}},
COUNT (i.id) AS "Item total",
SUM(i.checkout_total) AS "Total_Checkouts",
SUM(i.renewal_total) AS "Total_Renewals",
SUM(i.checkout_total) + SUM(i.renewal_total) AS "Total_Circulation",
ROUND(AVG(i.price) FILTER(WHERE i.price>'0' AND i.price <'10000'),2)::MONEY AS "AVG_price",
COUNT(i.id) FILTER(WHERE c.id IS NOT NULL) AS "total_checked_out",
ROUND(100.0 * (CAST(COUNT(i.id) FILTER(WHERE c.id IS NOT NULL) AS NUMERIC (12,2)) / CAST(COUNT (i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_checked_out",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS "have_circed_within_1_year",
ROUND(100.0 * (CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS NUMERIC (12,2)) / CAST(COUNT (i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_1_year",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS "have_circed_within_3_years",
ROUND(100.0 * (CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS NUMERIC (12,2)) / CAST(COUNT (i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_3_years",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS "have_circed_within_5_years",
ROUND(100.0 * (CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS NUMERIC (12,2)) / CAST(COUNT (i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_5_years",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt is not null) AS "have_circed_within_5+_years",
ROUND(100.0 * (CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt is not null) AS NUMERIC (12,2)) / CAST(COUNT (i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_5+_years",
COUNT (i.id) FILTER(WHERE i.last_checkout_gmt is null) AS "0_circs",
ROUND(100.0 * (CAST(COUNT(i.id) FILTER(WHERE i.last_checkout_gmt is null) AS NUMERIC (12,2)) / CAST(COUNT (i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_0_circs",
ROUND((COUNT(i.id) *(AVG(i.price) FILTER(WHERE i.price>'0' AND i.price <'10000'))/(NULLIF((SUM(i.checkout_total) + SUM(i.renewal_total)),0))),2)::MONEY AS "Cost_Per_Circ_By_AVG_price",
round(cast(SUM(i.checkout_total) + SUM(i.renewal_total) as numeric (12,2))/cast(COUNT (i.id) as numeric (12,2)), 2) as turnover,
round(100.0 * (cast(COUNT(i.id) as numeric (12,2)) / (select cast(COUNT (i.id) as numeric (12,2))from sierra_view.item_record i WHERE i.location_code ~ '{{Location}}' AND i.item_status_code not in ({{Item_Status_Codes}}))), 6)||'%' as relative_item_total,
round(100.0 * (cast(SUM(i.checkout_total) + SUM(i.renewal_total) as numeric (12,2)) / (SELECT cast(SUM(i.checkout_total) + SUM(i.renewal_total) as numeric (12,2)) from sierra_view.item_record i WHERE i.location_code ~ '{{location}}' AND i.item_status_code NOT IN ({{Item_Status_Codes}}))), 6)||'%' as relative_circ
FROM
sierra_view.item_record i
JOIN
call_number_mod ic
ON
i.id = ic.item_record_id
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
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
sierra_view.material_property_myuser m
ON
b.bcode2 = m.code
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code
JOIN
sierra_view.language_property_myuser LN
ON
b.language_code = ln.code
WHERE location_code ~ '{{location}}' and item_status_code not IN ({{Item_Status_Codes}})
GROUP BY 1
ORDER BY 1;
