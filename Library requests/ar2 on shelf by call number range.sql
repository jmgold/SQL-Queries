/*
Jeremy Goldstein
Minuteman Library Network
Captures number of items/titles of shelf vs checked out at this moment.
*/

WITH call_number_mod AS(
SELECT
i.item_record_id,
i.call_number_norm AS call_original,
CASE
	--author in call
	WHEN b.best_author_norm != '' AND i.call_number_norm ~ SPLIT_PART(TRANSLATE(b.best_author_norm,'Ã¢Ã¡Ã£Ã¤Ã¥ÄÄƒÄ…ÃÃ‚ÃƒÃ„Ã…Ä€Ä‚Ä„Ã¨Ã©Ã©Ã©ÃªÃ«Ä“Ä•Ä—Ä™Ä›Ä’Ä”Ä–Ä˜ÄšÃ¬Ã­Ã®Ã¯Ã¬Ä©Ä«Ä­ÃŒÃÃŽÃÃŒÄ¨ÄªÄ¬Ã³Ã´ÃµÃ¶ÅÅÅ‘Ã’Ã“Ã”Ã•Ã–ÅŒÅŽÅÃ¹ÃºÃ»Ã¼Å©Å«Å­Å¯Ã™ÃšÃ›ÃœÅ¨ÅªÅ¬Å®','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu'), ' ',1) THEN REGEXP_REPLACE(SPLIT_PART(BTRIM(i.call_number_norm),SPLIT_PART(TRANSLATE(b.best_author_norm,'Ã¢Ã¡Ã£Ã¤Ã¥ÄÄƒÄ…ÃÃ‚ÃƒÃ„Ã…Ä€Ä‚Ä„Ã¨Ã©Ã©Ã©ÃªÃ«Ä“Ä•Ä—Ä™Ä›Ä’Ä”Ä–Ä˜ÄšÃ¬Ã­Ã®Ã¯Ã¬Ä©Ä«Ä­ÃŒÃÃŽÃÃŒÄ¨ÄªÄ¬Ã³Ã´ÃµÃ¶ÅÅÅ‘Ã’Ã“Ã”Ã•Ã–ÅŒÅŽÅÃ¹ÃºÃ»Ã¼Å©Å«Å­Å¯Ã™ÃšÃ›ÃœÅ¨ÅªÅ¬Å®','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu'), ' ',1),1),'[^\w\s\.]','','g')
   --first characters of author in call
	WHEN b.best_author_norm != '' AND i.call_number_norm ~ SUBSTRING(SPLIT_PART(TRANSLATE(b.best_author_norm,'Ã¢Ã¡Ã£Ã¤Ã¥ÄÄƒÄ…ÃÃ‚ÃƒÃ„Ã…Ä€Ä‚Ä„Ã¨Ã©Ã©Ã©ÃªÃ«Ä“Ä•Ä—Ä™Ä›Ä’Ä”Ä–Ä˜ÄšÃ¬Ã­Ã®Ã¯Ã¬Ä©Ä«Ä­ÃŒÃÃŽÃÃŒÄ¨ÄªÄ¬Ã³Ã´ÃµÃ¶ÅÅÅ‘Ã’Ã“Ã”Ã•Ã–ÅŒÅŽÅÃ¹ÃºÃ»Ã¼Å©Å«Å­Å¯Ã™ÃšÃ›ÃœÅ¨ÅªÅ¬Å®','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu'), ' ',1)FROM 1 FOR 3) THEN REGEXP_REPLACE(SPLIT_PART(BTRIM(i.call_number_norm),SUBSTRING(SPLIT_PART(TRANSLATE(b.best_author_norm,'Ã¢Ã¡Ã£Ã¤Ã¥ÄÄƒÄ…ÃÃ‚ÃƒÃ„Ã…Ä€Ä‚Ä„Ã¨Ã©Ã©Ã©ÃªÃ«Ä“Ä•Ä—Ä™Ä›Ä’Ä”Ä–Ä˜ÄšÃ¬Ã­Ã®Ã¯Ã¬Ä©Ä«Ä­ÃŒÃÃŽÃÃŒÄ¨ÄªÄ¬Ã³Ã´ÃµÃ¶ÅÅÅ‘Ã’Ã“Ã”Ã•Ã–ÅŒÅŽÅÃ¹ÃºÃ»Ã¼Å©Å«Å­Å¯Ã™ÃšÃ›ÃœÅ¨ÅªÅ¬Å®','aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu'), ' ',1)FROM 1 FOR 3),1),'[^\w\s\.]','','g')
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
AND ir.location_code ~ '^ar2'
)

SELECT
COALESCE(CASE
   --call number does not exist
	WHEN ip.call_number_norm = '' OR ip.call_number_norm IS NULL THEN 'no call number'
	--biographies
   WHEN ip.call_number_norm ~ '^b [a-z].*' THEN 'b'
	WHEN ip.call_number_norm ~ '^j b [a-z].*' THEN 'jb'
	WHEN ip.call_number_norm ~ '^teen b [a-z].*' THEN 'teen b'
	WHEN ip.call_number_norm ~ '^dvd b [a-z].*' THEN 'dvd b'
	WHEN ip.call_number_norm ~ '^cd-book b [a-z].*' THEN 'cd-book b'
	WHEN ip.call_number_norm ~ '^(.*biography|.*biog|.*bio)\y' THEN BTRIM(SUBSTRING(ip.call_number_norm FROM '^.*((biography)|(biog)|(bio))\y'))
	--ej
	WHEN ip.call_number_norm ~ '^e\s?j [a-z].*' THEN 'ej'
	--fic
	WHEN ip.call_number_norm ~ '^fic [a-z].*' THEN 'fic'
	WHEN ip.call_number_norm ~ '^j fic [a-z].*' THEN 'j fic'
	WHEN ip.call_number_norm ~ '^teen fic [a-z].*' THEN 'teen fic'
	WHEN ip.call_number_norm ~ '^cd-book fic [a-z].*' THEN 'cd-book fic'
	--pb
	WHEN ip.call_number_norm ~ '^pb [a-z].*' THEN 'pb'
	--pj
	WHEN ip.call_number_norm ~ '^pj [a-z].*' THEN 'pj'
	--dvd tv show
	WHEN ip.call_number_norm ~ '^dvd tv show [a-z].*' THEN 'dvd tv show'
	--graphic novels & manga
   WHEN ip.call_number_norm ~ '^(.*graphic|.*manga)' AND ip.call_number_norm !~ '\d' THEN BTRIM(SUBSTRING(ip.call_number_norm FROM '^(.*graphic|.*manga)'))
	--j console
	WHEN ip.call_number_norm ~ '^j wiiu [a-z].*' THEN 'j wiiu'
	WHEN ip.call_number_norm ~ '^j wii [a-z].*' THEN 'j wii'
	WHEN ip.call_number_norm ~ '^j switch [a-z].*' THEN 'j switch'
	WHEN ip.call_number_norm ~ '^j xbox one [a-z].*' THEN 'j xbox one'
	--lot
	WHEN ip.call_number_norm ~ '^lot [a-z].*' THEN 'lot'
	--call number contains no numbers and a 1 or 2 words
	WHEN ip.call_number_norm !~ '\d' AND (ip.call_number_norm !~ '\s' OR ip.call_number_norm ~ '^([\w\-\.]+\s)[\w\-\.]+$') THEN BTRIM(ip.call_number_norm)
	--call number contains no numbers 2 words
	--WHEN i.call_number_norm !~ '\d' AND i.call_number_norm ~ '^([\w\-\.]+\s)[\w\-\.]+$' THEN SPLIT_PART(REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi'),' ','1')
	--call number contains no numbers and 3-4 words
	WHEN ip.call_number_norm !~ '\d' AND ip.call_number_norm ~ '^([\w\-\.]+\s)([\w\-\.]+\s){0,2}[\w\-\.]+$' THEN BTRIM(REVERSE(REGEXP_REPLACE(REVERSE(ip.call_number_norm),'^[\w\-\.\/\'']*\s', '')))
	--call number contains no numbers and > 4 words
   WHEN ip.call_number_norm !~ '\d' THEN BTRIM(SPLIT_PART(ip.call_number_norm,' ','1')||' '||SPLIT_PART(ip.call_number_norm,' ','2')||' '||SPLIT_PART(ip.call_number_norm,' ','3'))
	--only digits are a cutter at the end
	WHEN REGEXP_REPLACE(REVERSE(ip.call_number_norm), '^[a-z]*[0-9]{2,3}[a-z]\s?','') !~ '\d' THEN BTRIM(REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(REVERSE(ip.call_number_norm),'^[a-z]*[0-9]{2}[a-z]\s?', ''),'^[\w\-\.\'']*\s', '')))
   --contains an LC number in the 1000-9999 range
   WHEN ip.call_number_norm ~ '(^|\s)[a-z]{1,3}\s?[0-9]{4}(\.\d{1,3})?\s?\.?[a-z][0-9]' THEN BTRIM(SUBSTRING(ip.call_number_norm,'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'000-'||SUBSTRING(ip.call_number_norm,'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'999')
	--contains an LC number in the 001-999 range
	WHEN ip.call_number_norm ~ '(^|\s)[a-z]{1,3}\s?[0-9]{1,3}(\.\d{1,3})?\s?\.[a-z][0-9]' THEN BTRIM(SUBSTRING(ip.call_number_norm,'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}')||'001-999')
   --contains a dewey number
	WHEN ip.call_number_norm ~ '[0-9]{3}\.?[0-9]*' THEN BTRIM(SUBSTRING(ip.call_number_norm,'^[a-z\s\[\]\&\-\.\,\(\)]*[0-9]{2}')||'0')
  --PS4
	WHEN ip.call_number_norm ~ 'ps4' THEN BTRIM(REVERSE(REGEXP_REPLACE(REVERSE(ip.call_number_norm),'^[\w\-\.\/\'']*\s', '')))
	--mp3
	WHEN ip.call_number_norm ~ 'mp3' THEN BTRIM(REVERSE(REGEXP_REPLACE(REVERSE(ip.call_number_norm),'^[\w\-\.\/\'']*\s', '')))
	--leftover number suffixes
   WHEN ip.call_number_norm ~ '\d' THEN BTRIM(REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(ip.call_number_norm,'\d\w*','')),'^[\w\-\.\/\'']*\s', '')))
ELSE 'unknown'
END,'unknown') AS call_number_range,
COUNT(i.id) AS total_items,
COUNT(i.id) FILTER(WHERE C.id IS NULL AND i.item_status_code NOT IN ('t','!')) AS items_on_shelf,
COUNT(i.id) FILTER(WHERE c.id IS NULL AND i.item_status_code = 't') AS items_in_transit,
COUNT(i.id) FILTER(WHERE c.id IS NULL AND i.item_status_code = '!') AS items_on_holdshelf,
COUNT(i.id) FILTER(WHERE C.id IS NOT NULL) AS items_checked_out,
ROUND(100.0 * (CAST(COUNT(i.id) FILTER(WHERE C.id IS NULL AND i.item_status_code NOT IN ('t','!')) AS NUMERIC (12,2)) / CAST(COUNT(i.id) AS NUMERIC (12,2))), 4)||'%' AS percentage_items_on_shelf,
COUNT(DISTINCT l.bib_record_id) AS total_tiles,
COUNT(DISTINCT l.bib_record_id) FILTER(WHERE C.id IS NULL AND i.item_status_code NOT IN ('t','!')) AS titles_on_shelf,
COUNT(DISTINCT l.bib_record_id) FILTER(WHERE C.id IS NULL AND i.item_status_code = 't') AS titles_in_transit,
COUNT(DISTINCT l.bib_record_id) FILTER(WHERE C.id IS NULL AND i.item_status_code = '!') AS titles_on_holdshelf,
COUNT(DISTINCT l.bib_record_id) FILTER(WHERE C.id IS NOT NULL) AS titles_checked_out,
ROUND(100.0 * (CAST(COUNT(DISTINCT l.bib_record_id) FILTER(WHERE C.id IS NULL AND i.item_status_code NOT IN ('t','!')) AS NUMERIC (12,2)) / CAST(COUNT(DISTINCT l.bib_record_id) AS NUMERIC (12,2))), 4)||'%' AS percentage_titles_on_shelf

FROM
sierra_view.item_record i
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
LEFT JOIN
sierra_view.checkout C
ON
i.id = C.item_record_id
JOIN
call_number_mod ic
ON
i.id = ic.item_record_id
JOIN sierra_view.bib_record b
ON
l.bib_record_id = b.id
JOIN
sierra_view.material_property_myuser m
ON
b.bcode2 = m.code
JOIN
sierra_view.language_property_myuser LN
ON
b.language_code = ln.code
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id --AND rm.creation_date_gmt < {{date_limit}}

WHERE
i.location_code ~ '^ar2' AND i.item_status_code NOT IN ('$','w','n','z','r','e')
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.

GROUP BY 1
ORDER BY 1;