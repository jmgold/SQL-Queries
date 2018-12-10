/*
Jeremy Goldstein
Minuteman Library Network

Used to find mass market paperbacks (that measure between 17 and 19 centimeters) that were not cataloged as such.
*/

SELECT
id2reckey(i.id)||'a'
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
b.bib_record_id = s.record_id AND s.field_type_code = 'r' AND s.marc_tag = '300' and s.tag = 'c'
AND
substring(s.content from '[0-9]+')::numeric between 17 and 19
WHERE
i.location_code LIKE 'ntn%'