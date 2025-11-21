/*
Jeremy Goldstein
Minuteman Library Network
Identifies items exhibiting one of a number of common barcode data entry problems
*/

SELECT
  a.location,
  a.item_number,
  MAX(a.barcode) AS barcode,
  a.field_name,
  a.error_type,
  '' AS "ITEM BARCODE ERRORS",
  '' AS "https://sic.minlib.net/reports/20"

FROM (
  --Finds barcodes with invalid numbers or strings that appear to be barcodes located in invalid fields
  SELECT
    i.location_code AS location,
    rm.record_type_code||rm.record_num||'a' AS item_number,
    p.index_entry AS barcode,
    v.short_name AS field_name,
    CASE
	   WHEN v.short_name != 'BARCODE' THEN 'Incorrect Field'
	   ELSE 'Invalid Barcode'
    END AS error_type

  FROM sierra_view.item_record i
  JOIN sierra_view.record_metadata rm
    ON i.id = rm.id
  JOIN sierra_view.phrase_entry p
    ON i.id = p.record_id
  JOIN sierra_view.varfield_type vt
    ON p.index_tag = vt.code
	 AND vt.record_type_code = 'i'
  JOIN sierra_view.varfield_type_name v
    ON vt.id = v.varfield_type_id
	 AND v.iii_language_id = '1'

  WHERE i.location_code ~ '{{location}}'
    --exclude itype for ills that are not relevant to these cleanup efforts
	 AND i.itype_code_num != '241'  
    AND ( 
      --barcodes not in barcode
	   (p.index_entry ~ '^\d{14}$' AND p.index_tag != 'b')
      --invalid barcodes
      OR (p.index_tag = 'b' AND p.index_entry !~ '^30022|30308|30423|31155|31189|31213|31323|31619|31712|31848|31852|31906|31911|31927|32051|32211|32405|33014|33015|33016|33017|33018|34860|34861|34862|34863|34864|34865|34866|34867|34868|34869|34870|34871|34872|35957|36216|36287|36294|36304|36504|36998|38106|32101\d{9}$')
    )

  UNION

  --Finds items with multiple barcode fields
  SELECT
    i.location_code,
    rm.record_type_code||rm.record_num||'a',
    CONCAT(p1.index_entry,', ',STRING_AGG(p2.index_entry,', ')),
    'BARCODE',
    'Multiple Fields'

  FROM sierra_view.item_record i
  JOIN sierra_view.record_metadata rm
    ON i.id = rm.id
  JOIN sierra_view.phrase_entry p1
    ON i.id = p1.record_id
	 AND p1.index_tag = 'b'
  JOIN sierra_view.phrase_entry p2
    ON i.id = p2.record_id
	 AND p2.index_tag = 'b'
	 AND p1.index_entry != p2.index_entry
    AND p2.index_entry ~ '^30022|30308|30423|31155|31189|31213|31323|31619|31712|31848|31852|31906|31911|31927|32051|32211|32405|33014|33015|33016|33017|33018|34860|34861|34862|34863|34864|34865|34866|34867|34868|34869|34870|34871|34872|35957|36216|36287|36294|36304|36504|36998|38106|32101\d{9}$'
  
  WHERE i.itype_code_num != '241'
    AND i.location_code ~ '{{location}}'

  GROUP BY 1,2,4,5, p1.index_entry

  UNION
  --Finds items missing barcodes
  SELECT
    i.location_code,
    rm.record_type_code||rm.record_num||'a',
    ip.barcode,
    'NA',
    'Missing Barcode'

  FROM sierra_view.item_record i
  JOIN sierra_view.record_metadata rm
    ON i.id = rm.id 
  JOIN sierra_view.item_record_property ip
    ON i.id = ip.item_record_id
	 AND ip.barcode = ''
	 
  WHERE i.itype_code_num != '241'
    AND i.location_code ~ '{{location}}'
)a

GROUP BY 1,2,4,5

ORDER BY 1,2