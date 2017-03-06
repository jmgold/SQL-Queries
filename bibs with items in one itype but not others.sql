--use to gather bibs where a library owns items in a specified itype and no other itypes.

--originally to find instances at Cambridge where there were speed views and not standard dvds.

--export to excel and sort to isolate desired portion of results.

select 'b'||bib.record_num||'a',
bib.title,
count (case when item.itype_code_num = '21' then 1 else null end) as itype_21_count,
count (case when item.itype_code_num != '21' then 1 else null end) as other_itype_count
from
sierra_view.bib_view as bib
join
sierra_view.bib_record_item_record_link as link
on
bib.id = link.bib_record_id
join
sierra_view.item_view as item
on
item.id = link.item_record_id
where
item.agency_code_num = '3'
group by 1, 2;