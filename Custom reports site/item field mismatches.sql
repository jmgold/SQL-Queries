/*
Jeremy Goldstein
Minuteman Library Network

Identifies outlying items based on a rarely used combination of 2 fixed fields
to look for possible data entry errors
*/

WITH item_group AS
(
SELECT
{{field_one}} AS field_one,
{{field_two}} AS field_two,
--field options are
--i.location_code,
--i.itype_code_num,
--i.icode1,
--p.material_code,
--b.language_code,
COUNT(DISTINCT i.id) AS item_count

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record b
ON
l.bib_record_id = b.id
JOIN
sierra_view.bib_record_property p
ON
b.id = p.bib_record_id

WHERE i.location_code ~ '{{location}}'
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.

GROUP BY 1,2
)

SELECT
id2reckey(i.id)||'a' AS item_number,
{{field_one}},
{{field_two}}
--field options are
--i.location_code,
--i.itype_code_num,
--i.icode1
--p.material_code,
--b.language_code,

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record b
ON
l.bib_record_id = b.id
JOIN
sierra_view.bib_record_property p
ON
b.id = p.bib_record_id
JOIN
item_group ig
ON
	CASE WHEN '{{field_one}}' = 'i.location_code' THEN (i.location_code::VARCHAR = ig.field_one::VARCHAR)
	WHEN '{{field_one}}' = 'i.itype_code_num' THEN (i.itype_code_num::VARCHAR = ig.field_one::VARCHAR)
	WHEN '{{field_one}}' = 'i.icode1' THEN (i.icode1::VARCHAR = ig.field_one::VARCHAR)
	WHEN '{{field_one}}' = 'b.language_code' THEN (b.language_code::VARCHAR = ig.field_one::VARCHAR)
	WHEN '{{field_one}}' = 'p.material_code' THEN (p.material_code::VARCHAR = ig.field_one::VARCHAR)
	END
AND 
	CASE WHEN '{{field_two}}' = 'i.location_code' THEN (i.location_code::VARCHAR = ig.field_two::VARCHAR)
	WHEN '{{field_two}}' = 'i.itype_code_num' THEN (i.itype_code_num::VARCHAR = ig.field_two::VARCHAR)
	WHEN '{{field_two}}' = 'i.icode1' THEN (i.icode1::VARCHAR = ig.field_two::VARCHAR)
	WHEN '{{field_two}}' = 'b.language_code' THEN (b.language_code::VARCHAR = ig.field_two::VARCHAR)
	WHEN '{{field_two}}' = 'p.material_code' THEN (p.material_code::VARCHAR = ig.field_two::VARCHAR)
	END
AND ig.item_count <= {{item_limit}}
AND i.location_code ~ '{{location}}'
