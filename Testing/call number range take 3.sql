WITH call_number_mod AS(
SELECT
i.item_record_id,
CASE
	WHEN a.index_entry != '' AND translate(i.call_number_norm,'âáãäåāăąÁÂÃÄÅĀĂĄèéééêëēĕėęěĒĔĖĘĚìíîïìĩīĭÌÍÎÏÌĨĪĬóôõöōŏőÒÓÔÕÖŌŎŐùúûüũūŭůÙÚÛÜŨŪŬŮ','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu') LIKE '% '||SPLIT_PART(a.index_entry, ' ',1)||'%' THEN SPLIT_PART(TRIM(BOTH FROM translate(i.call_number_norm,'âáãäåāăąÁÂÃÄÅĀĂĄèéééêëēĕėęěĒĔĖĘĚìíîïìĩīĭÌÍÎÏÌĨĪĬóôõöōŏőÒÓÔÕÖŌŎŐùúûüũūŭůÙÚÛÜŨŪŬŮ','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu')),SPLIT_PART(a.index_entry, ' ',1),1)
	--author truncated to 3 characters
	WHEN a.index_entry != '' AND translate(i.call_number_norm,'âáãäåāăąÁÂÃÄÅĀĂĄèéééêëēĕėęěĒĔĖĘĚìíîïìĩīĭÌÍÎÏÌĨĪĬóôõöōŏőÒÓÔÕÖŌŎŐùúûüũūŭůÙÚÛÜŨŪŬŮ','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu') LIKE '% '||SUBSTRING(SPLIT_PART(a.index_entry, ' ',1)FROM 1 FOR 3)||'%' THEN SPLIT_PART(TRIM(BOTH FROM translate(i.call_number_norm,'âáãäåāăąÁÂÃÄÅĀĂĄèéééêëēĕėęěĒĔĖĘĚìíîïìĩīĭÌÍÎÏÌĨĪĬóôõöōŏőÒÓÔÕÖŌŎŐùúûüũūŭůÙÚÛÜŨŪŬŮ','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu')),SUBSTRING(SPLIT_PART(a.index_entry, ' ',1)FROM 1 FOR 3),1)
	WHEN i.call_number_norm LIKE '%'||SPLIT_PART(t.index_entry, ' ',1)||'%' THEN SPLIT_PART(TRIM(BOTH FROM i.call_number_norm),SPLIT_PART(t.index_entry, ' ',1),1)
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
LEFT JOIN
sierra_view.phrase_entry a
ON
l.bib_record_id = a.record_id AND a.index_tag = 'a' AND a.varfield_type_code = 'a' AND a.occurrence = 0
LEFT JOIN
sierra_view.phrase_entry t
ON
l.bib_record_id = t.record_id AND t.index_tag = 't' AND t.varfield_type_code = 't' AND t.occurrence = 0

)

SELECT
ip.call_number_norm AS original,
i.call_number_norm AS modified,
COALESCE(CASE
   --call number does not exist
	WHEN i.call_number_norm = '' OR i.call_number_norm IS NULL THEN 'no call number'
	--biographies
   WHEN i.call_number_norm ~ '^(.*biography|.*biog|.*bio)' THEN SUBSTRING(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi')FROM '^.*((biography)|(biog)|(bio))')
	--graphic novels & manga
   WHEN i.call_number_norm ~ '^(.*graphic|.*manga)' AND i.call_number_norm !~ '\d' THEN SUBSTRING(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi')FROM '^(.*graphic|.*manga)')
	--call number contains no numbers and a 1 or 2 words
	WHEN i.call_number_norm !~ '\d' AND (i.call_number_norm !~ '\s' OR i.call_number_norm ~ '^([\w\-\.]+\s)[\w\-\.]+$') THEN REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi')
	--call number contains no numbers 2 words
	--WHEN i.call_number_norm !~ '\d' AND i.call_number_norm ~ '^([\w\-\.]+\s)[\w\-\.]+$' THEN SPLIT_PART(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi'),' ','1')
	--call number contains no numbers and 3-4 words
	WHEN i.call_number_norm !~ '\d' AND i.call_number_norm ~ '^([\w\-\.]+\s)([\w\-\.]+\s){0,2}[\w\-\.]+$' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi')),'^[\w\-\.\/\'']*\s', ''))
	--call number contains no numbers and > 4 words
   WHEN i.call_number_norm !~ '\d' THEN SPLIT_PART(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi'),' ','1')||' '||SPLIT_PART(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi'),' ','2')||' '||SPLIT_PART(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi'),' ','3')
	--only digits are a cutter at the end
	WHEN REGEXP_REPLACE(REVERSE(i.call_number_norm), '^[a-z]*[0-9]{2,3}[a-z]\s?','') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi')),'^[a-z]*[0-9]{2}[a-z]\s?', ''),'^[\w\-\.\'']*\s', ''))
   --contains an LC number in the 1000-9999 range
   WHEN i.call_number_norm ~ '(^|\s)[a-z]{1,3}\s?[0-9]{4}(\.\d{1,3})?\s?\.?[a-z][0-9]' THEN SUBSTRING(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]',''),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'000-'||SUBSTRING(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'999'
	--contains an LC number in the 001-999 range
	WHEN i.call_number_norm ~ '(^|\s)[a-z]{1,3}\s?[0-9]{1,3}(\.\d{1,3})?\s?\.[a-z][0-9]' THEN SUBSTRING(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}')||'001-999'
   --contains a dewey number
	WHEN i.call_number_norm ~ '[0-9]{3}\.?[0-9]*' THEN SUBSTRING(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[0-9]{2}')||'0'
  --PS4
	WHEN i.call_number_norm ~ 'ps4' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi')),'^[\w\-\.\/\'']*\s', ''))
	--mp3
	WHEN i.call_number_norm ~ 'mp3' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi')),'^[\w\-\.\/\'']*\s', ''))
	--leftover number suffixes
   WHEN i.call_number_norm ~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi'),'\d\w*','')),'^[\w\-\.\/\'']*\s', ''))
	ELSE 'unknown'
END,'unknown') AS call_number_range,
SUM(ARRAY_LENGTH(REGEXP_SPLIT_TO_ARRAY(TRIM(BOTH FROM i.call_number_norm),'\s'),1)) AS word_count,
id2reckey(ir.id)||'a'

FROM
call_number_mod i
JOIN
sierra_view.item_record ir
ON
i.item_record_id = ir.id
--avoid comcat items
JOIN
sierra_view.item_record_property ip
ON
i.item_record_id = ip.item_record_id
AND
ir.itype_code_num != '241'
AND
ir.location_code ~ '^fst'
GROUP BY 1,2,5
ORDER BY 3, 2