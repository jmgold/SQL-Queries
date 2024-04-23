/*
Jeremy Goldstein
Minuteman Library Network

Finds adult non-fiction titles owned by Needham that should be recataloged as YA
*/

WITH title_list AS (
SELECT
mb.id,
'b'||mb.record_num||'a' AS bib_number,
b.best_title AS title,
b.best_author AS author,
b.publish_year

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
i.id = l.item_record_id
JOIN
sierra_view.record_metadata m
ON
i.id = m.id
JOIN
sierra_view.bib_record br
ON
l.bib_record_id = br.id
AND br.bcode3 NOT IN ('g','o','r','z','l','q','n')
JOIN
sierra_view.record_metadata mb
ON
b.bib_record_id = mb.id
JOIN
sierra_view.phrase_entry d
ON b.bib_record_id = d.record_id AND d.index_tag = 'd' AND d.is_permuted = FALSE
JOIN
sierra_view.leader_field ml
ON b.bib_record_id = ml.record_id
JOIN
sierra_view.control_field f
ON b.bib_record_id = f.record_id

WHERE
b.material_code IN ('a')
GROUP BY
1,2,3,4,5
HAVING
COUNT(i.id) FILTER (WHERE i.location_code ~ '^nee[^y]' AND i.icode1 BETWEEN '10' AND '100') > 0
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
AND COUNT(i.id) FILTER (WHERE i.location_code ~ '^[^n][^e][^e]y') > 0
)

SELECT
TRIM(REPLACE(ip.call_number,'|a','')) AS call_number,
COALESCE(v.field_content,'') AS volume,
ip.barcode,
t.title,
t.author,
t.bib_number

FROM
title_list t
JOIN
sierra_view.bib_record_item_record_link l
ON
t.id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code ~ '^nee[^y]' AND i.icode1 BETWEEN '10' AND '100'
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
LEFT JOIN
sierra_view.varfield v
ON
i.id = v.record_id AND v.varfield_type_code = 'v'

ORDER BY 1,2