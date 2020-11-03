/*Jeremy Goldstein
Minuteman Library Network

Identifies item records with invalid barcodes
Due to invalid numbers or barcodes in the wrong varfields
*/

SELECT
i.location_code AS location,
rm.record_type_code||rm.record_num||'a' AS item_number,
p.index_entry AS barcode,
v.short_name AS field_name
FROM
sierra_view.phrase_entry p
JOIN
sierra_view.record_metadata rm
ON
p.record_id = rm.id AND rm.record_type_code = 'i'
JOIN
sierra_view.varfield_type vt
ON
p.index_tag = vt.code AND vt.record_type_code = 'i'
JOIN
varfield_type_name v
ON
vt.id = v.varfield_type_id AND v.iii_language_id = '1'
JOIN
sierra_view.item_record i
ON
rm.id = i.id AND i.itype != '241' AND i.location_code ~ '{{location}}'

WHERE 
--barcodes not in barcode
(p.index_entry ~ '^\d{14}' AND p.index_tag != 'b')
--invalid barcodes
OR (p.index_tag = 'b' AND p.index_entry !~ '^30022|30308|30423|31155|31189|31213|31323|31619|31712|31848|31852|31906|31911|31927|32051|32211|32405|33014|33015|33016|33017|33018|34860|34861|34862|34863|34864|34865|34866|34867|34868|34869|34870|34871|34872|35957|36216|36287|36294|36304|36504|36998|38106|32101\d{9}$')
