/*Jeremy Goldstein
Minuteman Library Network

Finds bib records used for course reserves that are no longer in use
Is passed owning location as a variable

*/

SELECT 
DISTINCT id2reckey(bp.bib_record_id)||'a' AS bib_number,
id2reckey(i.id)||'a' AS item_number,
i.location_code AS location,
bp.best_title AS title,
TO_DATE(SUBSTRING(note.field_content,1,8), 'mm-dd-yy') AS off_reserve_date,
SPLIT_PART(SPLIT_PART(note.field_content, ' CIRCED',1), 'FOR ', 2) AS course
FROM
sierra_view.item_record AS i
LEFT JOIN
sierra_view.course_record_item_record_link AS ci
On 
ci.item_record_id = i.id
JOIN
sierra_view.bib_record_item_record_link AS bi
ON
bi.item_record_id = i.id
Join sierra_view.bib_view AS b
ON
bi.bib_record_id = b.id
JOIN sierra_view.bib_record_property bp
ON
b.id = bp.bib_record_id
LEFT JOIN
sierra_view.varfield note
ON
i.id = note.record_id AND note.varfield_type_code = 'r' AND note.field_content LIKE '%OFF RESERVE%'
WHERE
ci.course_record_id IS NULL AND b.bcode3 = 'r'
AND i.location_code ~ {{Location}}

order BY 2,3
;