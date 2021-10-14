/*
Jeremy Goldstein
Minuteman Library Network

Identifies weeding candidates by looking for titles with many copies elsewhere in the network
and where the local turnover is less than the network turnover
*/

WITH bib_list AS
(
SELECT
l.bib_record_id,
SUM(i.checkout_total) AS local_checkout_total,
COUNT(i.id) AS local_copies,
MAX(i.last_checkout_gmt::DATE) AS local_last_checkout,
STRING_AGG(id2reckey(i.id)||'a',',') AS item_numbers,
STRING_AGG(DISTINCT TRIM(REPLACE(ip.call_number,'|a','')),',') AS call_numbers,
STRING_AGG(DISTINCT i.icode1::VARCHAR,', ') AS scat_codes,
STRING_AGG(DISTINCT i.itype_code_num::VARCHAR,', ') AS itypes
 
FROM
sierra_view.bib_record_item_record_link l
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code ~ '{{location}}'
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
AND i.item_status_code NOT IN ({{item_status_codes}})
AND (i.itype_code_num NOT BETWEEN '100' AND '183' AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y'))--{{age_level}}
--age_level options are
--(i.itype_code_num NOT BETWEEN '100' AND '183' AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')) --adult
--(i.itype_code_num BETWEEN '150' AND '183' OR SUBSTRING(i.location_code,4,1) = 'j') --juv
--(i.itype_code_num BETWEEN '100' AND '133' OR SUBSTRING(i.location_code,4,1) = 'y') --ya
--i.location_code ~ '\w' --all
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id AND rm.creation_date_gmt::DATE < {{created_date}}
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id AND b.material_code IN ({{mat_type}}) 
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
GROUP BY 1
)

SELECT *
FROM( 
SELECT
rm.record_type_code||rm.record_num||'a' AS bib_number,
b.best_title AS title,
b.best_author AS author,
bl.local_checkout_total,
bl.local_copies,
ROUND(CAST(bl.local_checkout_total AS NUMERIC (12,2)) / CAST(bl.local_copies AS NUMERIC (12,2)), 2) AS local_turnover,
bl.local_last_checkout,
SUM(i.checkout_total) AS non_local_checkout_total,
COUNT(i.id) AS non_local_copies,
ROUND(CAST(SUM(i.checkout_total) AS NUMERIC (12,2))/CAST(COUNT(i.id) AS NUMERIC (12,2)), 2) AS non_local_turnover,
bl.item_numbers,
bl.call_numbers,
bl.scat_codes,
bl.itypes
 
FROM
sierra_view.bib_record_item_record_link l
JOIN
bib_list bl
ON l.bib_record_id = bl.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code !~ '{{location}}'
AND i.item_status_code NOT IN ({{item_status_codes}})
JOIN
sierra_view.record_metadata rm
ON
bl.bib_record_id = rm.id
JOIN
sierra_view.bib_record_property b
ON
rm.id = b.bib_record_id AND b.material_code IN ({{mat_type}}) 
{{#if exclude}}
LEFT JOIN
sierra_view.subfield v
ON
i.id = v.record_id AND v.field_type_code = 'v'
{{/if exclude}}

GROUP BY 1,2,3,4,5,6,7,11,12,13,14
HAVING
COUNT(i.id) > {{item_count}}
{{#if exclude}}
AND COUNT(v.*) = 0 
{{/if exclude}}
)a
WHERE a.local_turnover < a.non_local_turnover
ORDER BY a.non_local_copies - a.local_copies DESC, a.non_local_turnover - a.local_turnover DESC