--Used to gather the amount spent on items broken down by scat code.  Highly imperfect totals.
select
id2reckey(b.id)||'a',
i.icode1,
p.paid_amount
from
sierra_view.bib_record b
join
sierra_view.bib_record_item_record_link l
on b.id = l.bib_record_id
join
sierra_view.item_view i
on
--limit to library and orders created in a date range
i.id = l.item_record_id and i.record_creation_date_gmt >= '2016-07-01' and i.location_code like 'wat%'
join
sierra_view.bib_record_order_record_link ol
on
b.id = ol.bib_record_id
join
sierra_view.order_view o
on
--limit to the same library as line 15
ol.order_record_id = o.id and o.record_creation_date_gmt >= '2016-07-01' and o.accounting_unit_code_num = '34'
join
sierra_view.order_record_paid p
on
o.id=p.order_record_id
order by 2,1,3