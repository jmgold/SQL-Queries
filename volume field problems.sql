--Identifies bib records with some but not all attached items use volume fields.
--Use to identify records with incorrect item level holds

select 'b'||bib.record_num||'a' as "record_num",
bib.title as "title",
count(case when (varfield.varfield_type_code = 'v' and varfield.field_content is not null) then 1 else null end) as "volume_count",
count(item.id) as "item_count"
from
sierra_view.bib_view as bib
join
sierra_view.bib_record_item_record_link as link
on
bib.id = link.bib_record_id
join
sierra_view.item_record as item
on
item.id = link.item_record_id
left join
sierra_view.varfield as varfield
on
item.id = varfield.record_id and varfield.varfield_type_code = 'v'
group by 1, 2
having (count(item.id) - count(case when (varfield.varfield_type_code = 'v' and varfield.field_content is not null) then 1 else null end)) > 0
AND count(case when (varfield.varfield_type_code = 'v' and varfield.field_content is not null) then 1 else null end) != 0
-- 6 to 1 ratio of items to items with volumes seems like decent but imperfect marker of the point past which it is no longer an effective use of time to check each record
AND (count(item.id)/ count(case when (varfield.varfield_type_code = 'v' and varfield.field_content is not null) then 1 else null end)) >= 6


