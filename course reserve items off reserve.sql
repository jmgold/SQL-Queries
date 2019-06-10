--Jeremy Goldstein
--Minuteman Library Network

--Finds bib records used for course reserves that are no longer in use

select 
distinct id2reckey(i.id)||'a' AS record_num,
--'r'||r.record_num||'a',
i.location_code,
bp.best_title
--v.field_content
from
--sierra_view.varfield as v
--join
sierra_view.item_record as i
--ON
--v.record_id = i.id
left join
sierra_view.course_record_item_record_link as ci
On 
ci.item_record_id = i.id
--left join
--sierra_view.course_view as r
--ON
--ci.course_record_id = r.id
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
--varfield_type_code = 'r' and 
ci.course_record_id is null and b.bcode3 = 'r'
AND i.location_code LIKE 'dea%'


order BY 2,3
;