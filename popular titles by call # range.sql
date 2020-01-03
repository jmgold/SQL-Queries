SELECT
rm.record_type_code||rm.record_num||'a' AS record_num,
--b.bib_record_id,
b.best_title AS title,
COUNT(i.id) AS total_items,
SUM(i.year_to_date_checkout_total) AS last_year_to_date_checkout_total,
SUM(i.year_to_date_checkout_total) AS year_to_date_checkout_total,
SUM(i.checkout_total) AS checkout_total,
SUM(i.checkout_total) + SUM(i.renewal_total) AS circulation_total,
h.count_holds_on_title AS total_holds

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id --AND i.virtual_type_code != '$'
LEFT JOIN
(SELECT
t.bib_record_id,
count(t.bib_record_id) as count_holds_on_title
FROM
(SELECT
h.pickup_location_code,
h.record_id,
r.record_type_code, 
r.record_num,
--reconciles bib,item and volume level holds
CASE
    WHEN r.record_type_code = 'i' THEN (
        SELECT
        l.bib_record_id
        FROM
        sierra_view.bib_record_item_record_link as l
        WHERE
        l.item_record_id = h.record_id
        LIMIT 1
    )
    WHEN r.record_type_code = 'j' THEN (
        SELECT
        l.bib_record_id
        FROM
        sierra_view.bib_record_volume_record_link as l
        WHERE
        l.volume_record_id = h.record_id
        LIMIT 1
    )
    WHEN r.record_type_code = 'b' THEN (
        h.record_id
    )
    ELSE NULL
END AS bib_record_id

FROM
sierra_view.hold as h

JOIN
sierra_view.record_metadata as r
ON
  r.id = h.record_id) AS t
GROUP BY 1
HAVING
count(t.bib_record_id) > 1
) AS h
ON
b.bib_record_id = h.bib_record_id

WHERE b.bib_record_id IN
(
SELECT
l.bib_record_id

FROM
sierra_view.bib_record_item_record_link l
JOIN
sierra_view.item_record_property ip
ON
l.item_record_id = ip.item_record_id AND
COALESCE(CASE
  /*call number does not exist*/
  WHEN ip.call_number_norm = '' OR ip.call_number_norm IS NULL THEN 'no call number'
  /*biographies*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ '^(.*biography|.*biog|.*bio)' THEN SUBSTRING(REGEXP_REPLACE(ip.call_number_norm,'\(|\)|\[|\]','','gi')FROM '^(.*biography|.*biog|.*bio)')
  /*graphic novels & manga*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ '^(.*graphic|.*manga)' AND REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM ip.call_number_norm)), '^[0-9]{1,3}\s?\.?v|lov|c|#|s|nosaes|aes|tes|res|seires|p|tp|trap|loc|noitcelloc|b|kb|koob', '') !~ '\d' THEN SUBSTRING(REGEXP_REPLACE(ip.call_number_norm,'\(|\)|\[|\]','','gi')FROM '^(.*graphic|manga)')
  /*call number contains no numbers and ends with a name in the form last, first and could use initials*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) !~ '\d' AND REVERSE(REPLACE(TRIM(BOTH FROM ip.call_number_norm),'-','')) ~ '^[a-z\.]+\s?(.[a-z]\s?)*,[\.a-z]' THEN REVERSE(REGEXP_REPLACE(REPLACE(REPLACE(REVERSE(REGEXP_REPLACE(REPLACE(TRIM(BOTH FROM ip.call_number_norm),'-',''),'(\(|\)|\[|\])','','gi')),' .',''),'.',''),'^\w+\s?,?\w+', ''))
  /*call number contains no numbers and a single word*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) !~ '\d' AND TRIM(BOTH FROM ip.call_number_norm) !~ '\s' THEN REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi')
  /*call number contains no numbers 2 words*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) !~ '\d' AND TRIM(BOTH FROM ip.call_number_norm) ~ '^([\w\-\.]+\s)[\w\-\.]+$' THEN SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),' ','1')
  /*call number contains no numbers and 3-4 words*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) !~ '\d' AND TRIM(BOTH FROM ip.call_number_norm) ~ '^([\w\-\.]+\s)([\w\-\.]+\s){0,2}[\w\-\.]+$' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi')),'^[\w\-\.\/\'']*\s', ''))
  /*call number contains no numbers and > 4 words*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) !~ '\d' THEN SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),' ','1')||' '||SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),' ','2')||' '||SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),' ','3')
  /*only digits are a year at the end*/
  WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM ip.call_number_norm)), '^[0-9]{3}[12]', '') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM REGEXP_REPLACE(ip.call_number_norm,'\s?\d{4}$','')),'\(|\)|\[|\]','','gi')),'^\w+\s', ''))
  /*only digits are a volume,copy,series, etc number at the end*/
  WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM ip.call_number_norm)), '^[0-9]{1,3}\s?\.?v|lov|c|#|s|nosaes|aes|tes|res|seires|p|tp|trap|loc|noitcelloc|b|kb|koob', '') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM REGEXP_REPLACE(ip.call_number_norm,'\(|\)|\[|\]','','gi'))),'^[0-9]{1,3}\s?\.?v|lov|c|#|s|nosaes|aes|tes|res|seires|p|tp|trap|loc|noitcelloc|b|kb|koob',''),'^\w+\s', ''))
  /*only digits are a cutter at the end*/
  WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM ip.call_number_norm)), '^[a-z]*[0-9]{2,3}[a-z]\s?','') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi')),'^[a-z]*[0-9]{2}[a-z]\s?', ''),'^[\w\-\.\'']*\s', ''))
  /*contains an LC number in the 1000-9999 range*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ '(^|\s)[a-z]{1,3}\s?[0-9]{4}(\.\d{1,3})?\s?\.?[a-z][0-9]' THEN SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]',''),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'000-'||SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'999'
  /*contains an LC number in the 001-999 range*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ '(^|\s)[a-z]{1,3}\s?[0-9]{1,3}(\.\d{1,3})?\s?\.[a-z][0-9]' THEN SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}')||'001-999'
  /*contains a dewey number*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ '[0-9]{3}\.?[0-9]*' THEN SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[0-9]{2}')||'0'
  /*PS4*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ 'ps4' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi')),'^[\w\-\.\/\'']*\s', ''))
  /*mp3*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ 'mp3' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi')),'^[\w\-\.\/\'']*\s', ''))
  /*leftover number suffixes*/
  WHEN TRIM(BOTH FROM ip.call_number_norm) ~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(TRIM(BOTH FROM ip.call_number_norm),'\(|\)|\[|\]','','gi'),'\d\w*','')),'^[\w\-\.\/\'']*\s', ''))
  ELSE 'unknown'
  END,'unknown') BETWEEN 'ya fic' AND 'ya fic z'
--ip.call_number ~ '^75'
)

GROUP BY 1,2,8
HAVING COUNT(i.id) FILTER (WHERE i.location_code ~ '^brk') = 0
	AND COUNT(i.id) FILTER (WHERE i.location_code !~ '^brk') > 0

ORDER BY 8 DESC

  