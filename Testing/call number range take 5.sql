SELECT
rec_num,
call_number,
call_number_norm,
SCHEMA,
CASE
	WHEN SCHEMA = 'LC' AND call_number_norm ~ '(^|\s)[a-z]{1,3}\s?[0-9]{4}(\.\d{1,3})?\s?\.?[a-z][0-9]' THEN BTRIM(SUBSTRING(call_number_norm,'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'000-'||SUBSTRING(call_number_norm,'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'999')
	WHEN SCHEMA = 'LC' THEN BTRIM(SUBSTRING(call_number_norm,'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}')||'001-999')
	WHEN SCHEMA = 'DDC' THEN BTRIM(SUBSTRING(call_number_norm,'^[a-z\s\[\]\&\-\.\,\(\)]*[0-9]{2}')||'0')
	WHEN SCHEMA = 'OTHER' AND (call_number_norm !~ '\s' OR call_number_norm ~ '^([\w\-\.]+\s)[\w\-\.]+$') THEN BTRIM(call_number_norm) 
	WHEN SCHEMA = 'OTHER' AND call_number_norm !~ '\d' AND call_number_norm ~ '^([\w\-\.]+\s)([\w\-\.]+\s){0,2}[\w\-\.]+$' THEN BTRIM(REVERSE(REGEXP_REPLACE(REVERSE(call_number_norm),'^[\w\-\.\/\'']*\s', '')))
	WHEN SCHEMA = 'OTHER' AND call_number_norm !~ '\d' THEN BTRIM(SPLIT_PART(call_number_norm,' ','1')||' '||SPLIT_PART(call_number_norm,' ','2')||' '||SPLIT_PART(call_number_norm,' ','3'))
	END AS range
FROM
(SELECT 
rm.record_type_code||rm.record_num||'a' AS rec_num,
i.call_number,
i.call_number_norm,
CASE
	WHEN LOWER(i.call_number_norm) ~ '\y[a-z]{1,3}[0-9]{1,4}(\.[a-z]{1,3}[0-9]{1,4})?' THEN 'LC'
	WHEN i.call_number_norm ~ '[0-9]{1,3}(\.[0-9]{1,3})' THEN 'DDC'
	ELSE 'OTHER'
END AS schema

FROM
sierra_view.item_record_property i
JOIN
sierra_view.record_metadata rm
ON
i.item_record_id = rm.id) AS inner_query

ORDER BY RANDOM()
LIMIT 1000