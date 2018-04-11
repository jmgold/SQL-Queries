--Jeremy Goldstein
--Minuteman Library Network

--Finds items where a bad value was entered into the price field, typically due to scanning a barcode into the field or missing a decimal

----Automated with the python script template (https://github.com/jmgold/SQL-Queries/blob/master/python_script_template.py)

select
id2reckey(record_id)||'a',
location_code,
price
from
sierra_view.item_record
where
price>'999999'
--itypes 221 and above are generally used for e-resources and equipment 
or (price>='1000' and item_status_code != 'o' and item_status_code != 'w' and itype_code_num < '221')
order by 2
