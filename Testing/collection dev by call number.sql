/*
Jeremy Goldstein
Minuteman Lirary Network
Gathers together various performance metrics for portions of a library's collection
Is passed variables for owning location, item status to exclude from the report, and the field to group the collection by
*/
SELECT
COALESCE(CASE
  /*call number does not exist*/
  WHEN ip.call_number_norm = '' OR ip.call_number_norm IS NULL THEN 'no call number'
  /*biographies*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ '^(.*biography|.*biog|.*bio)' THEN SUBSTRING(REGEXP_REPLACE(ip.call_number_norm,'\(|\)|\[|\]','','gi')FROM '^(.*biography|.*biog|.*bio)')
  /*graphic novels & manga*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ '^(.*graphic|.*manga)' AND REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM ip.call_number_norm)), '^[0-9]{1,3}\s{0,1}\.{0,1}v|lov|c|#|s|nosaes|aes|tes|res|seires|p|tp|trap|loc|noitcelloc|b|kb|koob', '') !~ '\d' THEN SUBSTRING(REGEXP_REPLACE(ip.call_number_norm,'\(|\)|\[|\]','','gi')FROM '^(.*graphic|manga)')
  /*call number contains no numbers and ends with a name in the form last, first and could use initials*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) !~ '\d' AND REVERSE(REPLACE(TRIM(BOTH FROM ip.call_number_norm),'-','')) ~ '^[a-z\.]+\s{0,1}(.[a-z]\s{0,1})*,[\.a-z]' THEN REVERSE(REGEXP_REPLACE(REPLACE(REPLACE(REVERSE(REGEXP_REPLACE(REPLACE(TRIM(BOTH FROM ip.call_number_norm),'-',''),'(\(|\)|\[|\])','','gi')),' .',''),'.',''),'^\w+\s{0,1},{0,1}\w+', ''))
  /*call number contains no numbers and a single word*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) !~ '\d' AND TRIM(BOTH FROM ip.call_number_norm) !~ '\s' THEN REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi')
  /*call number contains no numbers 2 words*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) !~ '\d' AND TRIM(BOTH FROM ip.call_number_norm) ~ '^([\w\-\.]+\s)[\w\-\.]+$' THEN SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),' ','1')
  /*call number contains no numbers and 3-4 words*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) !~ '\d' AND TRIM(BOTH FROM ip.call_number_norm) ~ '^([\w\-\.]+\s)([\w\-\.]+\s){0,2}[\w\-\.]+$' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi')),'^[\w\-\.\/\'']*\s', ''))
  /*call number contains no numbers and > 4 words*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) !~ '\d' THEN SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),' ','1')||' '||SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),' ','2')||' '||SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),' ','3')
  /*only digits are a year at the end*/
  WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM ip.call_number_norm)), '^[0-9]{3}[12]', '') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM REGEXP_REPLACE(ip.call_number_norm,'\s{0,1}\d{4}$','')),'\(|\)|\[|\]','','gi')),'^\w+\s', ''))
  /*only digits are a volume,copy,series, etc number at the end*/
  WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM ip.call_number_norm)), '^[0-9]{1,3}\s{0,1}\.{0,1}v|lov|c|#|s|nosaes|aes|tes|res|seires|p|tp|trap|loc|noitcelloc|b|kb|koob', '') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM REGEXP_REPLACE(ip.call_number_norm,'\(|\)|\[|\]','','gi'))),'^[0-9]{1,3}\s{0,1}\.{0,1}v|lov|c|#|s|nosaes|aes|tes|res|seires|p|tp|trap|loc|noitcelloc|b|kb|koob',''),'^\w+\s', ''))
  /*only digits are a cutter at the end*/
  WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM ip.call_number_norm)), '^[a-z]*[0-9]{2,3}[a-z]\s{0,1}','') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi')),'^[a-z]*[0-9]{2}[a-z]\s{0,1}', ''),'^[\w\-\.\'']*\s', ''))
  /*contains an LC number in the 1000-9999 range*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ '(^|\s)[a-z]{1,3}\s{0,1}[0-9]{4}(\.\d{1,3}){0,1}\s{0,1}\.{0,1}[a-z][0-9]' THEN SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]',''),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s{0,1}[0-9]')||'000-'||SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s{0,1}[0-9]')||'999'
  /*contains an LC number in the 001-999 range*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ '(^|\s)[a-z]{1,3}\s{0,1}[0-9]{1,3}(\.\d{1,3}){0,1}\s{0,1}\.[a-z][0-9]' THEN SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}')||'001-999'
  /*contains a dewey number*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ '[0-9]{3}\.{0,1}[0-9]*' THEN SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[0-9]{2}')||'0'
  /*PS4*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ 'ps4' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi')),'^[\w\-\.\/\'']*\s', ''))
  /*mp3*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ 'mp3' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi')),'^[\w\-\.\/\'']*\s', ''))
  /*leftover number suffixes*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),'\d\w*','')),'^[\w\-\.\/\'']*\s', ''))
  ELSE 'unknown'
  END,'unknown'),
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
round(100.0 * (cast(COUNT(i.id) as numeric (12,2)) / (select cast(COUNT (i.id) as numeric (12,2))from sierra_view.item_record i WHERE i.location_code ~ '^act' AND i.item_status_code not in ('e','w','$','o'))), 6)||'%' as relative_item_total,
round(100.0 * (cast(SUM(i.checkout_total) + SUM(i.renewal_total) as numeric (12,2)) / (SELECT cast(SUM(i.checkout_total) + SUM(i.renewal_total) as numeric (12,2)) from sierra_view.item_record i WHERE i.location_code ~ '^act' AND i.item_status_code NOT IN ('e','w','$','o'))), 6)||'%' as relative_circ
FROM
sierra_view.item_record i
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
sierra_view.language_property_myuser ln
ON
b.language_code = ln.code
WHERE location_code ~ '^act' and item_status_code not IN ('e','w','$','o')
GROUP BY 1
ORDER BY 1;