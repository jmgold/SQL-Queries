/*
Jeremy Goldstein
Minuteman Library Network
Identifies patron records that were created using the online registration form,
no longer have the online patron ptype, but retain their system assigned barcode
*/

SELECT
record_type_code||record_num||'a' AS Record_num,
barcode AS Barcode,
ptype_code,
patron_agency_code_num AS Agency,
expiration_date_gmt::DATE AS Expiration_date

FROM
sierra_view.patron_view
WHERE
--ptype for online patron
ptype_code != '207'
--online registrations are given a barcode matching the record number
AND barcode = record_num::VARCHAR