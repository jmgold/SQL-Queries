SELECT
a.location,
a.item_number,
MAX(a.barcode) AS barcode,
a.field_name,
a.error_type,
'' AS "ITEM BARCODE ERRORS",
'' AS "https://sic.minlib.net/reports/20"

FROM
(
SELECT
i.location_code AS location,
rm.record_type_code||rm.record_num||'a' AS item_number,
p.index_entry AS barcode,
v.short_name AS field_name,
CASE
	WHEN v.short_name != 'BARCODE' THEN 'Incorrect Field'
	ELSE 'Invalid Barcode'
END AS error_type

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
sierra_view.varfield_type_name v
ON
vt.id = v.varfield_type_id AND v.iii_language_id = '1'
JOIN
sierra_view.item_record i
ON
rm.id = i.id AND i.itype_code_num != '241' AND i.location_code ~ '{{location}}'

WHERE 
--barcodes not in barcode
(p.index_entry ~ '^\d{14}$' AND p.index_tag != 'b')
--invalid barcodes
OR (p.index_tag = 'b' AND p.index_entry !~ '^30022|30308|30423|31155|31189|31213|31323|31619|31712|31848|31852|31906|31911|31927|32051|32211|32405|33014|33015|33016|33017|33018|34860|34861|34862|34863|34864|34865|34866|34867|34868|34869|34870|34871|34872|35957|36216|36287|36294|36304|36504|36998|38106|32101\d{9}$')

UNION

SELECT
i.location_code,
rm.record_type_code||rm.record_num||'a',
CONCAT(p1.index_entry,', ',STRING_AGG(p2.index_entry,', ')),
'BARCODE',
'Multiple Fields'

FROM
sierra_view.record_metadata rm
JOIN
sierra_view.phrase_entry p1
ON
p1.record_id = rm.id AND p1.index_tag = 'b'
JOIN
sierra_view.phrase_entry p2
ON
p2.record_id = rm.id AND p2.index_tag = 'b' AND p1.index_entry != p2.index_entry
AND p2.index_entry ~ '^30022|30308|30423|31155|31189|31213|31323|31619|31712|31848|31852|31906|31911|31927|32051|32211|32405|33014|33015|33016|33017|33018|34860|34861|34862|34863|34864|34865|34866|34867|34868|34869|34870|34871|34872|35957|36216|36287|36294|36304|36504|36998|38106|32101\d{9}$'
JOIN
sierra_view.item_record i
ON
rm.id = i.id AND i.itype_code_num != '241' AND i.location_code ~ '{{location}}'

GROUP BY 1,2,4,5, p1.index_entry

UNION

SELECT
i.location_code,
rm.record_type_code||rm.record_num||'a',
ip.barcode,
'NA',
'Missing Barcode'

FROM
sierra_view.record_metadata rm
JOIN
sierra_view.item_record i
ON
rm.id = i.id AND i.itype_code_num != '241' AND i.location_code ~ '{{location}}'
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id AND ip.barcode = ''
)a

GROUP BY 1,2,4,5

ORDER BY 1,2