/*
Jeremy Goldstein
Minuteman Library Network

Used to find mass market paperbacks (that measure between 17 and 19 centimeters) that were not cataloged as such.
*/

SELECT
id2reckey(i.id)||'a' AS item_number,
REPLACE(ip.call_number,'|a','') AS call_number,
id2reckey(b.bib_record_id)||'a' AS bib_number,
b.best_title AS title,
b.best_author AS author

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id AND b.material_code = 'a'
JOIN
sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.field_type_code = 'r' AND s.marc_tag = '300' AND s.tag = 'c'
AND SUBSTRING(s.content FROM '[0-9]+')::NUMERIC BETWEEN 17 AND 19
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
--limiting to call numbers that don't start with a number to weed out non-fiction
AND ip.call_number_norm !~ '^\d'

--limited to the adult book location and itypes that are not 1 'paperback'
WHERE
i.location_code = 'ntna'
AND i.itype_code_num != '1'