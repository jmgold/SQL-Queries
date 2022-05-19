/*
Jeremy Goldstein
Minuteman Library Network
Finds bib records used for course reserves that are no longer in use
*/
SELECT 
DISTINCT rm.record_type_code||rm.record_num||'a' AS record_num,
--'r'||r.record_num||'a',
i.location_code,
bp.best_title

FROM
sierra_view.item_record i
LEFT JOIN
sierra_view.course_record_item_record_link ci
ON 
ci.item_record_id = i.id
JOIN
sierra_view.bib_record_item_record_link bi
ON
bi.item_record_id = i.id
JOIN 
sierra_view.bib_record b
ON
bi.bib_record_id = b.id
JOIN 
sierra_view.bib_record_property bp
ON
b.id = bp.bib_record_id
JOIN
sierra_view.record_metadata rm
ON
b.id = rm.id

WHERE
ci.course_record_id IS NULL AND b.bcode3 = 'r'
AND i.location_code LIKE 'dea%'

ORDER BY 2,3
