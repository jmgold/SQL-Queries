--identifies patron records exhibiting various common data entry errors
select
id2reckey(p.id)||'a' as record_num,
p.barcode,
p.ptype_code,
p.pcode3,
p.home_library_code,
p.patron_agency_code_num,
a.addr1,
a.city,
a.postal_code,
v.field_content as email
from
sierra_view.patron_view as p
join		
sierra_view.varfield v		
on		
p.id = v.record_id and varfield_type_code = 'z'
join
sierra_view.patron_record_address as a
on p.id = a.patron_record_id
where
p.ptype_code = '1'
and
((p.home_library_code not like '%z' and p.home_library_code is not null) --failed to use pickup location code
or p.pcode3 != '1' --ma town does not match ptype
or p.patron_agency_code_num = '47' --improperly converted online registration
or a.addr1 is null
or a.city is null
or (a.postal_code !~ '^\d{5}' and a.postal_code !~'^\d{5}([\-]\d{4})') --zipcode not 5 digits
or p.barcode is null
or p.barcode !~ '^\d{14}' --barcode not 14 digits
--or duplicate barcode
or (v.field_content is not null and v.field_content !~ '(\@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-\.]+$)') --invalid e-mail format
)
order by
2,1