/*Jeremy Goldstein
Minuteman Library Network

Finds bib records used for course reserves that are no longer in use
Is passed owning location as a variable

*/

select 
distinct id2reckey(bp.bib_record_id)||'a' AS bib_number,
i.location_code as location,
bp.best_title as title
from
sierra_view.item_record as i
left join
sierra_view.course_record_item_record_link as ci
On 
ci.item_record_id = i.id
JOIN
sierra_view.bib_record_item_record_link as bi
ON
bi.item_record_id = i.id
Join sierra_view.bib_view as b
ON
bi.bib_record_id = b.id
JOIN sierra_view.bib_record_property bp
ON
b.id = bp.bib_record_id
where
ci.course_record_id is null and b.bcode3 = 'r'
AND i.location_code ~ {{Location}}

order BY 2,3
;