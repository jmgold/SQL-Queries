--Finds items where a barcode was scanned into the price field

select
'b'||id2reckey(record_id)||'a',
location_code,
price
from
sierra_view.item_record
where
price>'999999'
order by 2