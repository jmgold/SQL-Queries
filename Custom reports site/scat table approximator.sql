/*
Jeremy Goldstein
Minuteman Library Network
Report attempts to produce an in use scat table (icode1) by finding the most commonly used call # range and itype among items using each value
*/

WITH call_number_mod AS(
SELECT
i.item_record_id,
CASE
	WHEN b.best_author_norm != '' AND i.call_number_norm ~ ('^.+'||SPLIT_PART(b.best_author_norm, ' ',1)) THEN SPLIT_PART(TRIM(BOTH FROM i.call_number_norm),SPLIT_PART(b.best_author_norm, ' ',1),1)
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
JOIN
sierra_view.item_record ir
ON
i.item_record_id = ir.id AND ir.location_code ~ {{location}}
)

SELECT
DISTINCT a.scat,
FIRST_VALUE(a.call_number_range) OVER(PARTITION BY a.scat ORDER BY item_total DESC) AS call_num_range,
FIRST_VALUE(a.itype) OVER(PARTITION BY a.scat ORDER BY item_total DESC) AS itype
FROM(
SELECT
i.icode1 AS scat,
TRIM(BOTH FROM COALESCE(TRIM(BOTH FROM CASE
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
END,'unknown'))) AS call_number_range,
it.name as itype,
COUNT(i.id) AS item_total

FROM
sierra_view.item_record i
JOIN
call_number_mod ic
ON
i.id = ic.item_record_id
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code

WHERE i.location_code ~ {{location}}

GROUP BY 1,2,3)a
ORDER BY 1
