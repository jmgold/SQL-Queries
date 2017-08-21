--Finds items where a barcode was scanned into the price field

select
id2reckey(record_id)||'a',
location_code,
price
from
sierra_view.item_record
where
price>'999999' or (price>='1000' and item_status_code != 'o' and itype_code_num < '221')
order by 2
