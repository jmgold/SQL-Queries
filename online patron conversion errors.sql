--Identifies patron records that were created via online registration and were improperly converted to full records
SELECT
'p'||record_num||'a' AS Record_num,
barcode AS Barcode,
expiration_date_gmt AS Expiration_date
FROM
sierra_view.patron_view
WHERE
ptype_code = '207'
AND ((barcode > '9999999') OR expiration_date_gmt > (localtimestamp + interval '186 days'))