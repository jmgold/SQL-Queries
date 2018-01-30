--identifies patron records exhibiting various common data entry errors
select
id2reckey(p.id)||'a' as record_num,
p.barcode,
p.ptype_code,
p.home_library_code,
a.addr1,
a.city,
a.postal_code,
v.field_content as email
from
sierra_view.patron_view as p
join
sierra_view.patron_record_address as a
on p.id = a.patron_record_id
join
sierra_view.varfield v
on
p.id = v.record_id and varfield_type_code = 'z'
where
p.ptype_code = '1'
and
(p.home_library_code !~ 'actz'
or p.pcode3 != '1'
or a.addr1 is null
or a.city is null
or a.postal_code !~ '\d{5}([ \-]\d{4})'
or p.barcode is null
or (v.field_content is not null and v.field_content !~ '(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)'))
order by
2,1