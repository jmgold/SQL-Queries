SELECT
i.call_number_norm,
--needs to account for tv seasons, better LC parsing
COALESCE(CASE
   --call number does not exist
	WHEN i.call_number_norm = '' OR i.call_number_norm IS NULL THEN 'no call number'
	--call number contains no numbers and ends with a name in the form last, first and could use initials
	WHEN TRIM(BOTH FROM i.call_number_norm) !~ '\d' AND REVERSE(TRIM(BOTH FROM i.call_number_norm)) ~ '^[a-z\.]+\s?(.[a-z]\s?)*,[\.a-z]' THEN REVERSE(REGEXP_REPLACE(REPLACE(REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)),' .',''),'.',''),'^\w+\s?,?\w+', ''))
	--call number contains no numbers and multiple words
	WHEN TRIM(BOTH FROM i.call_number_norm) !~ '\d' AND call_number_norm ~ '\w\s\w' THEN REVERSE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)),'^[\w\-\.\'']*\s', ''))
	--call number contains no numbers and a single word
	WHEN TRIM(BOTH FROM i.call_number_norm) !~ '\d' THEN TRIM(BOTH FROM i.call_number_norm)
	--only digits are a year at the end
	WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)), '^[0-9]{3}[12]', '') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM REGEXP_REPLACE(i.call_number_norm,'\s?\d{4}$',''))),'^\w+\s', ''))
   --only digits are a volume or copy number at the end
	WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)), '^[0-9]{1,3}\s?\.?(v|lov|c)', '') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM REGEXP_REPLACE(i.call_number_norm,'\s?(v|vol|c)\.?\s?\d{1,4}$',''))),'^\w+\s', ''))
   --contains a dewey number
	WHEN TRIM(BOTH FROM i.call_number_norm) ~ '[0-9]{3}\.?[0-9]*' THEN SUBSTRING(TRIM(BOTH FROM i.call_number_norm),'^[a-z\s\[\]\&\-\.\,\(\)]*[0-9]{2}')||'0'
	--contains an LC number
	WHEN TRIM(BOTH FROM i.call_number_norm) ~ '[a-z]{1,2}\s?[0-9]{1,4}\.*' THEN SUBSTRING(TRIM(BOTH FROM i.call_number_norm),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]{2}')||'-'
	ELSE 'unknown'
END,'unknown') AS call_number_range,
id2reckey(ir.id)||'a'

FROM
sierra_view.item_record_property i
JOIN
sierra_view.item_record ir
ON
i.item_record_id = ir.id
AND
ir.location_code ~ '^act'
ORDER BY 2, 1