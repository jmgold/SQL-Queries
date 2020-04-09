/*
Jeremy Goldstein
Minuteman Library Network

Report provides an age of collection overview grouped around a selected fixed field.
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
)

SELECT
{{grouping}},
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year > 2019) AS "2020-",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 2010 AND 2019) AS "2010-2019",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 2000 AND 2009) AS "2000-2009",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1990 AND 1999) AS "1990-1999",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1980 AND 1989) AS "1980-1989",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1970 AND 1979) AS "1970-1979",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1960 AND 1969) AS "1960-1969",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1950 AND 1959) AS "1950-1959",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1940 AND 1949) AS "1940-1949",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1930 AND 1939) AS "1930-1939",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1920 AND 1929) AS "1920-1929",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1910 AND 1919) AS "1920-1919",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1900 AND 1909) AS "1910-1909",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year < 1900) AS "< 1900"
--and so on

FROM
sierra_view.bib_record b
JOIN
sierra_view.bib_record_property bp
ON
b.id = bp.bib_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
b.id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
JOIN
call_number_mod ic
ON
i.id = ic.item_record_id
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

WHERE location_code ~ '{{location}}'

GROUP BY 1
ORDER BY 1