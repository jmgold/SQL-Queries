/*
Jeremy Goldstein
Minuteman Library Network

Identifies outlying items based on a rarely used combination of 2 fixed fields
to look for possible data entry errors
*/

WITH item_group AS
(
SELECT
{{field_one}},
{{field_two}},
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
id2reckey(i.id)||'a',
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
item_group ig
ON
{{field_one}} = ig||RIGHT({{field_one}}, LEN({{field_one}}) -1)
--should produce an equation like i.itype_code_num = ig.itype_code_num
AND {{field_two}} = ig||RIGHT({{field_two}}, LEN({{field_two}}) -1) --i.icode1 = ig.icode1 --
AND ig.item_count <= {{item_limit}}
AND i.location_code ~ '{{location}}'
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
