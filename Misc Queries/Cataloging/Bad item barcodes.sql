/*Jeremy Goldstein
Minuteman Library Network

Identifies item records with invalid barcodes
Correct barcodes must be a 14 digit number starting with one of the 5 digit prefixes associated with one of our member libraries
*/

SELECT
SUBSTRING(location_code FROM 1 FOR 3) AS location,
record_type_code||record_num||'a' AS bib_number,
barcode

FROM
sierra_view.item_view
WHERE
REPLACE(barcode,' ','') !~ '^30022|30308|30423|31155|31189|31213|31323|31619|31712|31848|31852|31906|31911|31927|32051|32211|32405|33014|33015|33016|33017|33018|34860|34861|34862|34863|34864|34865|34866|34867|34868|34869|34870|34871|34872|35957|36216|36287|36294|36304|36504|36998|38106|32101\d{9}$'
AND barcode != ''
AND barcode !~ 'cmcat$'
AND itype_code_num != '241'
ORDER BY 1