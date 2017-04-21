--returns all records, sorted by count of barcode fields
select 
'p'||p.record_num||'a' as record_number,
count(v.field_content)
from
sierra_view.patron_view as p
join sierra_view.varfield_view as v
ON
p.record_num = v.record_num
where v.varfield_type_code = 'b' and v.record_type_code = 'p'
group by 1
order by 2 desc
