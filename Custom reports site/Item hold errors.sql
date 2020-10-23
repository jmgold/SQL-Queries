/*
Jeremy Goldstein
Minuteman Library Network

Identifies item level holds that should be transferred to bib level holds
*/

SELECT
ID2RECKEY(l.bib_record_id)||'a' AS bib_number,
b.best_title AS title,
STRING_AGG(DISTINCT h.pickup_location_code,', ') AS pickup_location_code,
COUNT(h.id) AS total_item_level_holds,
--COUNT(l.item_record_id) FILTER (WHERE i.is_available_at_library = TRUE) AS availabile_copies,
STRING_AGG(TO_CHAR(h.placed_gmt, 'YYYY-MM-DD'),', ') AS hold_placed

FROM
sierra_view.hold h

JOIN
sierra_view.record_metadata m
ON
h.record_id = m.id AND m.campus_code = '' AND m.record_type_code = 'i'
LEFT JOIN
sierra_view.bib_record_item_record_link l
ON
m.id = l.item_record_id AND m.record_type_code = 'i'
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
LEFT JOIN
sierra_view.varfield as v
on
i.id = v.record_id and v.varfield_type_code = 'v'
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id

WHERE
h.status = '0'
{{#if Exclude_volume}}
AND v.field_content IS NULL
{{/if Exclude_volume}}
{{#if Exclude_frozen}}
AND h.is_frozen = FALSE
{{/if Exclude_frozen}}
AND h.placed_gmt < {{date_placed}}
AND h.pickup_location_code ~ {{location}}
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.

GROUP BY 1,2
HAVING 
COUNT(i.id) FILTER (WHERE i.is_available_at_library = TRUE) > 0

UNION

SELECT
id2reckey(b.bib_record_id)||'a',
b.best_title,
h.pickup_location_code,
COUNT(h.id),
STRING_AGG(TO_CHAR(h.placed_gmt, 'YYYY-MM-DD'),', ')
FROM
sierra_view.hold h
JOIN
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
ON
h.record_id = i.id
LEFT JOIN
sierra_view.checkout
ON
i.id = checkout.item_record_id

WHERE
(h.status = 't' AND i.item_status_code != 't')
{{#if Exclude_frozen}}
AND h.is_frozen = FALSE
{{/if Exclude_frozen}}
AND h.placed_gmt < {{date_placed}}
AND h.pickup_location_code ~ {{location}}
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
AND checkout.id IS NULL

GROUP BY 1,2,3

ORDER BY 3,5