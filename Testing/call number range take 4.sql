WITH call_number_mod AS(
SELECT
i.item_record_id,
i.call_number_norm AS call_original,
CASE
	--author in call
	WHEN b.best_author_norm != '' AND i.call_number_norm ~ SPLIT_PART(TRANSLATE(b.best_author_norm,'âáãäåāăąÁÂÃÄÅĀĂĄèéééêëēĕėęěĒĔĖĘĚìíîïìĩīĭÌÍÎÏÌĨĪĬóôõöōŏőÒÓÔÕÖŌŎŐùúûüũūŭůÙÚÛÜŨŪŬŮ','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu'), ' ',1) THEN REGEXP_REPLACE(SPLIT_PART(BTRIM(i.call_number_norm),SPLIT_PART(TRANSLATE(b.best_author_norm,'âáãäåāăąÁÂÃÄÅĀĂĄèéééêëēĕėęěĒĔĖĘĚìíîïìĩīĭÌÍÎÏÌĨĪĬóôõöōŏőÒÓÔÕÖŌŎŐùúûüũūŭůÙÚÛÜŨŪŬŮ','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu'), ' ',1),1),'[^\w\s\.]','','g')
   --first characters of author in call
	WHEN b.best_author_norm != '' AND i.call_number_norm ~ SUBSTRING(SPLIT_PART(TRANSLATE(b.best_author_norm,'âáãäåāăąÁÂÃÄÅĀĂĄèéééêëēĕėęěĒĔĖĘĚìíîïìĩīĭÌÍÎÏÌĨĪĬóôõöōŏőÒÓÔÕÖŌŎŐùúûüũūŭůÙÚÛÜŨŪŬŮ','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu'), ' ',1)FROM 1 FOR 3) THEN REGEXP_REPLACE(SPLIT_PART(BTRIM(i.call_number_norm),SUBSTRING(SPLIT_PART(TRANSLATE(b.best_author_norm,'âáãäåāăąÁÂÃÄÅĀĂĄèéééêëēĕėęěĒĔĖĘĚìíîïìĩīĭÌÍÎÏÌĨĪĬóôõöōŏőÒÓÔÕÖŌŎŐùúûüũūŭůÙÚÛÜŨŪŬŮ','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu'), ' ',1)FROM 1 FOR 3),1),'[^\w\s\.]','','g')
	--title in call
	--WHEN i.call_number_norm ~ SPLIT_PART(b.best_title_norm, ' ',1) THEN REGEXP_REPLACE(SPLIT_PART(BTRIM(i.call_number_norm),SPLIT_PART(b.best_title_norm, ' ',1),1),'[^\w\s]','','g')
   --strip year from end
	WHEN BTRIM(i.call_number_norm) ~ '\s*[12][0-9]{3}$' THEN REGEXP_REPLACE(SUBSTRING(BTRIM(i.call_number_norm),1,STRPOS(BTRIM(i.call_number_norm), (regexp_match(BTRIM(i.call_number_norm), '\s*[12][0-9]{3}$'))[1])-1),'[^\w\s\.]','','g')
	--only digits are a volume,copy,series, etc number at the end
	WHEN BTRIM(i.call_number_norm) ~ '(v|vol|c|#|s|season|sea|set|ser|series|p|pt|part|col|collection|b|bk|book)\.?\s*[0-9]{1,3}$' THEN REGEXP_REPLACE(SUBSTRING(BTRIM(i.call_number_norm),1,STRPOS(BTRIM(i.call_number_norm), (regexp_match(BTRIM(i.call_number_norm), '(v|vol|c|#|s|season|sea|set|ser|series|p|pt|part|col|collection|b|bk|book)\.?\s*[0-9]{1,3}$'))[1])-1),'[^\w\s\.]','','g')
	ELSE REGEXP_REPLACE(BTRIM(i.call_number_norm),'[^\w\s\.]','','g')
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
i.item_record_id = ir.id
AND ir.itype_code_num != '241'
AND ir.location_code ~ '^fst'
)

SELECT
i.call_original AS original,
i.call_number_norm AS modified,
COALESCE(CASE
   --call number does not exist
	WHEN i.call_number_norm = '' OR i.call_number_norm IS NULL THEN 'no call number'
	--biographies
   WHEN i.call_number_norm ~ '^(.*biography|.*biog|.*bio)\y' THEN BTRIM(SUBSTRING(i.call_number_norm FROM '^.*((biography)|(biog)|(bio))\y'))
	--graphic novels & manga
   WHEN i.call_number_norm ~ '^(.*graphic|.*manga)' AND i.call_number_norm !~ '\d' THEN BTRIM(SUBSTRING(i.call_number_norm FROM '^(.*graphic|.*manga)'))
	--call number contains no numbers and a 1 or 2 words
	WHEN i.call_number_norm !~ '\d' AND (i.call_number_norm !~ '\s' OR i.call_number_norm ~ '^([\w\-\.]+\s)[\w\-\.]+$') THEN BTRIM(i.call_number_norm)
	--call number contains no numbers 2 words
	--WHEN i.call_number_norm !~ '\d' AND i.call_number_norm ~ '^([\w\-\.]+\s)[\w\-\.]+$' THEN SPLIT_PART(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi'),' ','1')
	--call number contains no numbers and 3-4 words
	WHEN i.call_number_norm !~ '\d' AND i.call_number_norm ~ '^([\w\-\.]+\s)([\w\-\.]+\s){0,2}[\w\-\.]+$' THEN BTRIM(REVERSE(REGEXP_REPLACE(REVERSE(i.call_number_norm),'^[\w\-\.\/\'']*\s', '')))
	--call number contains no numbers and > 4 words
   WHEN i.call_number_norm !~ '\d' THEN BTRIM(SPLIT_PART(i.call_number_norm,' ','1')||' '||SPLIT_PART(i.call_number_norm,' ','2')||' '||SPLIT_PART(i.call_number_norm,' ','3'))
	--only digits are a cutter at the end
	WHEN REGEXP_REPLACE(REVERSE(i.call_number_norm), '^[a-z]*[0-9]{2,3}[a-z]\s?','') !~ '\d' THEN BTRIM(REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(REVERSE(i.call_number_norm),'^[a-z]*[0-9]{2}[a-z]\s?', ''),'^[\w\-\.\'']*\s', '')))
   --contains an LC number in the 1000-9999 range
   WHEN i.call_number_norm ~ '(^|\s)[a-z]{1,3}\s?[0-9]{4}(\.\d{1,3})?\s?\.?[a-z][0-9]' THEN BTRIM(SUBSTRING(i.call_number_norm,'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'000-'||SUBSTRING(i.call_number_norm,'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'999')
	--contains an LC number in the 001-999 range
	WHEN i.call_number_norm ~ '(^|\s)[a-z]{1,3}\s?[0-9]{1,3}(\.\d{1,3})?\s?\.[a-z][0-9]' THEN BTRIM(SUBSTRING(i.call_number_norm,'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}')||'001-999')
   --contains a dewey number
	WHEN i.call_number_norm ~ '[0-9]{3}\.?[0-9]*' THEN BTRIM(SUBSTRING(i.call_number_norm,'^[a-z\s\[\]\&\-\.\,\(\)]*[0-9]{2}')||'0')
  --PS4
	WHEN i.call_number_norm ~ 'ps4' THEN BTRIM(REVERSE(REGEXP_REPLACE(REVERSE(i.call_number_norm),'^[\w\-\.\/\'']*\s', '')))
	--mp3
	WHEN i.call_number_norm ~ 'mp3' THEN BTRIM(REVERSE(REGEXP_REPLACE(REVERSE(i.call_number_norm),'^[\w\-\.\/\'']*\s', '')))
	--leftover number suffixes
   WHEN i.call_number_norm ~ '\d' THEN BTRIM(REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(i.call_number_norm,'\d\w*','')),'^[\w\-\.\/\'']*\s', '')))
	ELSE 'unknown'
END,'unknown') AS call_number_range,
SUM(ARRAY_LENGTH(REGEXP_SPLIT_TO_ARRAY(TRIM(BOTH FROM i.call_number_norm),'\s'),1)) AS word_count,
rm.record_type_code||rm.record_num||'a' AS record_num
FROM
call_number_mod i
JOIN
sierra_view.item_record ir
ON
i.item_record_id = ir.id
--avoid comcat items
AND
ir.location_code ~ '^fst'
JOIN
sierra_view.record_metadata rm
ON
i.item_record_id = rm.id AND rm.campus_code = ''
GROUP BY 1,2,5
ORDER BY 3,2
