SELECT
COALESCE(CASE
   --call number does not exist
	WHEN i.call_number_norm = '' OR i.call_number_norm IS NULL THEN 'no call number'
	--biographies
   WHEN TRIM(BOTH FROM i.call_number_norm) ~ '^(.*biography|.*biog|.*bio)' THEN SUBSTRING(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi')FROM '^(.*biography|.*biog|.*bio)')
	--graphic novels & manga
   WHEN TRIM(BOTH FROM i.call_number_norm) ~ '^(.*graphic|.*manga)' AND REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)), '^[0-9]{1,3}\s?\.?v|lov|c|#|s|nosaes|aes|tes|res|seires|p|tp|trap|loc|noitcelloc|b|kb|koob', '') !~ '\d' THEN SUBSTRING(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi')FROM '^(.*graphic|manga)')
	--call number contains no numbers and ends with a name in the form last, first and could use initials
	WHEN TRIM(BOTH FROM i.call_number_norm) !~ '\d' AND REVERSE(REPLACE(TRIM(BOTH FROM i.call_number_norm),'-','')) ~ '^[a-z\.]+\s?(.[a-z]\s?)*,[\.a-z]' THEN REVERSE(REGEXP_REPLACE(REPLACE(REPLACE(REVERSE(REGEXP_REPLACE(REPLACE(TRIM(BOTH FROM i.call_number_norm),'-',''),'(\(|\)|\[|\])','','gi')),' .',''),'.',''),'^\w+\s?,?\w+', ''))
  	--call number contains no numbers and a single word
	WHEN TRIM(BOTH FROM i.call_number_norm) !~ '\d' AND TRIM(BOTH FROM i.call_number_norm) !~ '\s' THEN REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'\(|\)|\[|\]','','gi')
	--call number contains no numbers 2 words
	WHEN TRIM(BOTH FROM i.call_number_norm) !~ '\d' AND TRIM(BOTH FROM i.call_number_norm) ~ '^([\w\-\.]+\s)[\w\-\.]+$' THEN SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'\(|\)|\[|\]','','gi'),' ','1')
	--call number contains no numbers and 3-4 words
	WHEN TRIM(BOTH FROM i.call_number_norm) !~ '\d' AND TRIM(BOTH FROM i.call_number_norm) ~ '^([\w\-\.]+\s)([\w\-\.]+\s){0,2}[\w\-\.]+$' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'\(|\)|\[|\]','','gi')),'^[\w\-\.\/\'']*\s', ''))
	--call number contains no numbers and > 4 words
   WHEN TRIM(BOTH FROM i.call_number_norm) !~ '\d' THEN SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'\(|\)|\[|\]','','gi'),' ','1')||' '||SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'\(|\)|\[|\]','','gi'),' ','2')||' '||SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'\(|\)|\[|\]','','gi'),' ','3')
	--only digits are a year at the end
	WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)), '^[0-9]{3}[12]', '') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM REGEXP_REPLACE(i.call_number_norm,'\s?\d{4}$','')),'\(|\)|\[|\]','','gi')),'^\w+\s', ''))
   --only digits are a volume,copy,series, etc number at the end
	WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)), '^[0-9]{1,3}\s?\.?v|lov|c|#|s|nosaes|aes|tes|res|seires|p|tp|trap|loc|noitcelloc|b|kb|koob', '') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi'))),'^[0-9]{1,3}\s?\.?v|lov|c|#|s|nosaes|aes|tes|res|seires|p|tp|trap|loc|noitcelloc|b|kb|koob',''),'^\w+\s', ''))
   --only digits are a cutter at the end
	WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)), '^[a-z]*[0-9]{2,3}[a-z]\s?','') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'\(|\)|\[|\]','','gi')),'^[a-z]*[0-9]{2}[a-z]\s?', ''),'^[\w\-\.\'']*\s', ''))
   --contains an LC number in the 1000-9999 range
   WHEN TRIM(BOTH FROM i.call_number_norm) ~ '(^|\s)[a-z]{1,3}\s?[0-9]{4}(\.\d{1,3})?\s?\.?[a-z][0-9]' THEN SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'\(|\)|\[|\]',''),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'000-'||SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'999'
	--contains an LC number in the 001-999 range
	WHEN TRIM(BOTH FROM i.call_number_norm) ~ '(^|\s)[a-z]{1,3}\s?[0-9]{1,3}(\.\d{1,3})?\s?\.[a-z][0-9]' THEN SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}')||'001-999'
   --contains a dewey number
	WHEN TRIM(BOTH FROM i.call_number_norm) ~ '[0-9]{3}\.?[0-9]*' THEN SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[0-9]{2}')||'0'
  --PS4
	WHEN TRIM(BOTH FROM i.call_number_norm) ~ 'ps4' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'\(|\)|\[|\]','','gi')),'^[\w\-\.\/\'']*\s', ''))
	--mp3
	WHEN TRIM(BOTH FROM i.call_number_norm) ~ 'mp3' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'\(|\)|\[|\]','','gi')),'^[\w\-\.\/\'']*\s', ''))
	--leftover number suffixes
   WHEN TRIM(BOTH FROM i.call_number_norm) ~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'\(|\)|\[|\]','','gi'),'\d\w*','')),'^[\w\-\.\/\'']*\s', ''))
	ELSE 'unknown'
END,'unknown') AS call_number_range,
COUNT(i.id) AS item_total,
SUM(ir.last_year_to_date_checkout_total) AS fy19_checkouts

FROM
sierra_view.item_record_property i
JOIN
sierra_view.item_record ir
ON
i.item_record_id = ir.id
AND ir.location_code ~ '^wyl'
JOIN
sierra_view.record_metadata meta
ON
i.item_record_id = meta.id AND meta.creation_date_gmt < '2019-07-01'

GROUP BY 1