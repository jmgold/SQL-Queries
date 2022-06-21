/*Jeremy Goldstein
Minuteman Library Network

Finds items where a bad value was entered into the price field
typically due to scanning a barcode into the field or missing a decimal
*/

SELECT
id2reckey(record_id)||'a' AS record_number,
location_code,
price::MONEY AS price

FROM
sierra_view.item_record

WHERE
price>'999999'
--itypes 221 and above are generally used for e-resources and equipment 
OR (price>='1000' AND item_status_code NOT IN ('o', 'w') AND itype_code_num < '221')

ORDER BY 2
