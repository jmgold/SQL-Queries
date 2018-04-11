--Jeremy Goldstein
--Minuteman Library Network


--use to gather bibs where a library owns multiple copies of a title.

select 'b'||bib.record_num||'a' as "record_num",
bib.title,
count(case when item.agency_code_num = '38' then 1 else null end) as "item_count",
sum(item.last_year_to_date_checkout_total) as "last_ytd_checkouts"
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
--Limit to a location
item.agency_code_num = '38'
group by 1, 2
having count(case when item.agency_code_num = '38' then 1 else null end) > 1
order by 3 desc
;
