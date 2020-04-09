/*
Jeremy Goldstein
Minuteman Library Network

Calculates the value of all items owned by your library checked out in a given time period
Is passed variables for date range, location and the field to group data by
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
CAST(SUM(i.price) AS MONEY) AS value,
COUNT(c.id) AS circ_count,
(CAST(SUM(i.price) AS MONEY) / COUNT(c.id)) as value_per_circ
FROM
sierra_view.circ_trans c
JOIN
sierra_view.item_record i
ON
c.item_record_id = i.id
JOIN
call_number_mod ic
ON
i.id = ic.item_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN sierra_view.bib_record b
ON
l.bib_record_id = b.id
JOIN
sierra_view.material_property mp
ON
b.bcode2 = mp.code
JOIN
sierra_view.material_property_name m
ON 
mp.id = m.material_property_id
JOIN
sierra_view.itype_property ip
ON
i.itype_code_num = ip.code_num
JOIN
sierra_view.itype_property_name it
ON 
ip.id = it.itype_property_id
JOIN
sierra_view.language_property_myuser ln
ON
b.language_code = ln.code
WHERE
c.op_code IN ('o', 'r')
AND
c.transaction_gmt::DATE {{relative_date}}
AND
i.location_code ~ '{{location}}'
GROUP BY 1
ORDER BY 1;