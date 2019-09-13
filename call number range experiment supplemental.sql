SELECT
i.call_number_norm,
--needs to account for [a-z][0-9]+ variations call numbers and suffixes
CASE
	--call number does not exist
	WHEN i.call_number_norm = '' OR i.call_number_norm IS NULL THEN 'no call number'
	--call number contains no numbers and ends with a name in the form last, first and could use initials
	WHEN i.call_number_norm !~ '\d' AND REVERSE(i.call_number_norm) ~ '^[a-z\.]+\s?(.[a-z]\s?)*,[\.a-z]' THEN REVERSE(REGEXP_REPLACE(REPLACE(REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)),' .',''),'.',''),'^\w+\s?,?\w+', ''))
	--call number contains no numbers and multiple words
	WHEN i.call_number_norm !~ '\d' AND call_number_norm ~ '\w\s\w' THEN REVERSE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)),'^[\w\-\.\'']*\s', ''))
		--call number contains no numbers and a single word
	WHEN i.call_number_norm !~ '\d' THEN i.call_number_norm
	--only digits are a year at the end
	WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)), '^[0-9]{3}[12]', '') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM REGEXP_REPLACE(i.call_number_norm,'\s?\d{4}$',''))),'^\w+\s', ''))
   --only digits are a cutter at the end
   WHEN REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm), '[a-z]+\d+\s*[a-z]*$', '') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'[a-z]+\d+\s*[a-z]*$','')),'^\w*\s', ''))
	--call numbers ends with a year
	WHEN REVERSE(TRIM(BOTH FROM i.call_number_norm)) ~ '^[0-9]{3}[12]' THEN SUBSTRING(REPLACE(REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)),'^[0-9]{3}[12]',''),'^\w*\s', '')),'.',''),'^.*?\d{2}')||'0'
	--call number ends with a cutter 
	WHEN TRIM(BOTH FROM i.call_number_norm) ~ '[0-9]\s[a-z]+\d+\s*[a-z]*$' THEN SUBSTRING(REPLACE(REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM i.call_number_norm),'[a-z]+\d+\s*[a-z]*$','')),'^\w*\s', '')),'.',''),'^.*?\d{2}')||'0'
	WHEN TRIM(BOTH FROM i.call_number_norm) ~ '[0-9]\s[a-z\-\.\'']+$' THEN SUBSTRING(REVERSE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)),'^\w+\s', '')),'^[0-9]{2}')||'0'
   --call number starts with a dewey number
	WHEN TRIM(BOTH FROM i.call_number_norm) ~ '^[0-9]' THEN SUBSTRING(TRIM(BOTH FROM i.call_number_norm),'^[0-9]{2}')||'0'
	ELSE 'unknown'
END AS call_number_range,
id2reckey(ir.id)||'a'

FROM
sierra_view.item_record_property i
JOIN
sierra_view.item_record ir
ON
i.item_record_id = ir.id
AND
ir.location_code ~ '^brk'
ORDER BY 2, 1