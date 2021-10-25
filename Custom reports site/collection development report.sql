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
	WHEN translate(b.best_author_norm,'âáãäåāăąÁÂÃÄÅĀĂĄèéééêëēĕėęěĒĔĖĘĚìíîïìĩīĭÌÍÎÏÌĨĪĬóôõöōŏőÒÓÔÕÖŌŎŐùúûüũūŭůÙÚÛÜŨŪŬŮ','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu') != '' AND translate(i.call_number_norm,'âáãäåāăąÁÂÃÄÅĀĂĄèéééêëēĕėęěĒĔĖĘĚìíîïìĩīĭÌÍÎÏÌĨĪĬóôõöōŏőÒÓÔÕÖŌŎŐùúûüũūŭůÙÚÛÜŨŪŬŮ','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu') ~ ('^.+'||SPLIT_PART(translate(b.best_author_norm,'âãáäåāăąÁÂÃÄÅĀĂĄèéééêëēĕėęěĒĔĖĘĚìíîïìĩīĭÌÍÎÏÌĨĪĬóôõöōŏőÒÓÔÕÖŌŎŐùúûüũūŭůÙÚÛÜŨŪŬŮ','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu'), ' ',1)) THEN SPLIT_PART(TRIM(BOTH FROM translate(i.call_number_norm,'âáãäåāăąÁÂÃÄÅĀĂĄèéééêëēĕėęěĒĔĖĘĚìíîïìĩīĭÌÍÎÏÌĨĪĬóôõöōŏőÒÓÔÕÖŌŎŐùúûüũūŭůÙÚÛÜŨŪŬŮ','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu')),SPLIT_PART(translate(b.best_author_norm,'âãäåāăąÁÂÃÄÅĀĂĄèééêëēĕėęěĒĔĖĘĚìíîïìĩīĭÌÍÎÏÌĨĪĬóôõöōŏőÒÓÔÕÖŌŎŐùúûüũūŭůÙÚÛÜŨŪŬŮ','aaaaaaaaaaaaaaaeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu'), ' ',1),1)
	WHEN i.call_number_norm ~ ('^.+'||SPLIT_PART(REGEXP_REPLACE(b.best_title_norm,'\*|\+|\?|\{',''), ' ',1)) THEN SPLIT_PART(TRIM(BOTH FROM i.call_number_norm),SPLIT_PART(b.best_title_norm, ' ',1),1)
   --only digits are a year at the end
	WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)), '^[0-9]{3}[12]', '') !~ '\d' THEN TRIM(BOTH FROM REGEXP_REPLACE(i.call_number_norm,'\s?\d{4}$',''))
   --only digits are a volume,copy,series, etc number at the end
	WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)), '^[0-9]{1,3}\s?\.?(v|lov|c|#|s|nosaes|aes|tes|res|seires|p|tp|trap|loc|noitcelloc|b|kb|koob)', '') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi'))),'^[0-9]{1,3}\s?\.?(v|lov|c|#|s|nosaes|aes|tes|res|seires|p|tp|trap|loc|noitcelloc|b|kb|koob)',''))
	ELSE TRIM(BOTH FROM i.call_number_norm)
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
/*Options are
TRIM(BOTH FROM COALESCE(CASE
   --call number does not exist
	WHEN ic.call_number_norm = '' OR ic.call_number_norm IS NULL THEN 'no call number'
	--biographies
   WHEN TRIM(BOTH FROM ic.call_number_norm) ~ '^(.*biography|.*biog|.*bio)' THEN SUBSTRING(REGEXP_REPLACE(ic.call_number_norm,'\(|\)|\[|\]','','gi')FROM '^(.*biography|.*biog|.*bio)')
	--graphic novels & manga
   WHEN ic.call_number_norm ~ '^(.*graphic|.*manga)' AND ic.call_number_norm !~ '\d' THEN SUBSTRING(REGEXP_REPLACE(ic.call_number_norm,'\(|\)|\[|\]','','gi')FROM '^(.*graphic|.*manga)')
	--call number contains no numbers and a 1 or 2 words
	WHEN ic.call_number_norm !~ '\d' AND (ic.call_number_norm !~ '\s' OR ic.call_number_norm ~ '^([\w\-\.]+\s)[\w\-\.]+$') THEN REGEXP_REPLACE(ic.call_number_norm,'\(|\)|\[|\]','','gi')
	--call number contains no numbers and 3-4 words
	WHEN TRIM(BOTH FROM ic.call_number_norm) !~ '\d' AND TRIM(BOTH FROM ic.call_number_norm) ~ '^([\w\-\.]+\s)([\w\-\.]+\s){0,2}[\w\-\.]+$' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi')),'^[\w\-\.\/'']*\s', ''))
	--call number contains no numbers and > 4 words
   WHEN TRIM(BOTH FROM ic.call_number_norm) !~ '\d' THEN SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi'),' ','1')||' '||SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi'),' ','2')||' '||SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi'),' ','3')
   --only digits are a cutter at the end
	WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM ic.call_number_norm)), '^[a-z]*[0-9]{2,3}[a-z]\s?','') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi')),'^[a-z]*[0-9]{2}[a-z]\s?', ''),'^[\w\-\.'']*\s', ''))
   --contains an LC number in the 1000-9999 range
   WHEN TRIM(BOTH FROM ic.call_number_norm) ~ '(^|\s)[a-z]{1,3}\s?[0-9]{4}(\.\d{1,3})?\s?\.?[a-z][0-9]' THEN SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]',''),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'000-'||SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'999'
	--contains an LC number in the 001-999 range
	WHEN TRIM(BOTH FROM ic.call_number_norm) ~ '(^|\s)[a-z]{1,3}\s?[0-9]{1,3}(\.\d{1,3})?\s?\.[a-z][0-9]' THEN SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}')||'001-999'
   --contains a dewey number
	WHEN TRIM(BOTH FROM ic.call_number_norm) ~ '[0-9]{3}\.?[0-9]*' THEN SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[0-9]{2}')||'0'
   --PS4
	WHEN TRIM(BOTH FROM ic.call_number_norm) ~ 'ps4' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi')),'^[\w\-\.\/'']*\s', ''))
	--mp3
	WHEN TRIM(BOTH FROM ic.call_number_norm) ~ 'mp3' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi')),'^[\w\-\.\/'']*\s', ''))
	--leftover number suffixes
   WHEN TRIM(BOTH FROM ic.call_number_norm) ~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi'),'\d\w*','')),'^[\w\-\.\/'']*\s', ''))
	ELSE 'unknown'
   END, 'unknown')) AS call_number_range
it.name AS itype
ln.name AS language
m.name AS mat_type
i.icode1 AS scat_code
i.location_code AS location
*/
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
round(100.0 * (cast(COUNT(i.id) as numeric (12,2)) / (select cast(COUNT (i.id) as numeric (12,2))from sierra_view.item_record i WHERE i.location_code ~ '{{location}}' AND i.item_status_code not in ({{Item_Status_Codes}}))), 6)||'%' as relative_item_total,
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
LEFT JOIN
sierra_view.language_property_myuser LN
ON
b.language_code = ln.code
WHERE location_code ~ '{{location}}'
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
AND item_status_code NOT IN ({{Item_Status_Codes}})
GROUP BY 1
ORDER BY 1;