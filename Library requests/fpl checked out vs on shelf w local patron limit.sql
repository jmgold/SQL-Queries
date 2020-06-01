/*
Jeremy Goldstein
Minuteman Library Network
Captures number of items/titles of shelf vs checked out at this moment.
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
i.location_code AS location,
COUNT(i.id) AS total_items,
COUNT(i.id) FILTER(WHERE C.id IS NULL) AS items_on_shelf,
COUNT(i.id) FILTER(WHERE C.id IS NOT NULL) AS items_checked_out,
ROUND(100.0 * (CAST(COUNT(i.id) FILTER(WHERE C.id IS NULL) AS NUMERIC (12,2)) / CAST(COUNT(i.id) AS NUMERIC (12,2))), 4)||'%' AS percentage_items_on_shelf,
COUNT(DISTINCT l.bib_record_id) AS total_tiles,
COUNT(DISTINCT l.bib_record_id) FILTER(WHERE C.id IS NULL) AS titles_on_shelf,
COUNT(DISTINCT l.bib_record_id) FILTER(WHERE C.id IS NOT NULL) AS titles_checked_out,
ROUND(100.0 * (CAST(COUNT(DISTINCT l.bib_record_id) FILTER(WHERE C.id IS NULL) AS NUMERIC (12,2)) / CAST(COUNT(DISTINCT l.bib_record_id) AS NUMERIC (12,2))), 4)||'%' AS percentage_titles_on_shelf,
COUNT(i.id) FILTER(WHERE C.ptype = '12') AS out_to_fpl_patrons

FROM
sierra_view.item_record i
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
i.id = rm.id AND rm.creation_date_gmt < NOW()::DATE


WHERE
i.location_code ~ '^fp' AND i.item_status_code NOT IN ('w','m','$')

--add creation date limit

GROUP BY 1
ORDER BY 1;