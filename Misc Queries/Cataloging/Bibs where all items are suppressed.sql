/*
Jeremy Goldstein
Minuteman Library Network

Bib where all attached items are suppressed
*/

SELECT
  rm.record_type_code||rm.record_num||'a' AS bnumber

FROM sierra_view.record_metadata rm
JOIN sierra_view.bib_record_item_record_link l
  ON rm.id = l.bib_record_id
JOIN sierra_view.item_record i
  ON l.item_record_id = i.id
  
GROUP BY 1
HAVING COUNT(i.id) FILTER(WHERE i.icode2 = 'n') > 0
  AND COUNT(i.id) FILTER(WHERE i.icode2 != 'n') = 0