/*
Jeremy Goldstein
Minuteman Library Network

Search for items that were checked out or in within a given timeframe
Broad search to compare to Discovery indexing.
*/

WITH bib_list AS (
SELECT
b.id

FROM sierra_view.bib_record b
JOIN sierra_view.bib_record_item_record_link l
  ON b.id = l.bib_record_id
JOIN sierra_view.item_record i
  ON l.item_record_id = i.id
LEFT JOIN sierra_view.circ_trans t
  ON i.id = t.item_record_id
  AND t.op_code IN ('o','i')
  --AND t.transaction_gmt BETWEEN '2025-07-02 12:55:00' AND '2025-07-03 08:00:00'
JOIN sierra_view.record_metadata rm
  ON i.id = rm.id
  --AND rm.record_last_updated_gmt BETWEEN '2025-07-02 12:55:00' AND '2025-07-03 08:00:00'

GROUP BY 1
HAVING COUNT(i.id) FILTER (WHERE (t.transaction_gmt BETWEEN '2025-07-02 12:55:00' AND '2025-07-03 08:00:00'
  AND rm.record_last_updated_gmt BETWEEN '2025-07-02 12:55:00' AND '2025-07-03 08:00:00')) > 0
  AND COUNT(i.id) FILTER (WHERE t.transaction_gmt > '2025-07-03 08:00:00' AND rm.record_last_updated_gmt > '2025-07-03 08:00:00') = 0

)

SELECT 
  rm.record_type_code||rm.record_num||'a' AS inumber,
  ip.barcode,
  CASE
    WHEN t.op_code = 'o' THEN 'Check out'
    ELSE 'Check In'
  END AS transaction_type,
  i.item_status_code,
  t.transaction_gmt,
  rm.record_last_updated_gmt,
  rm.previous_last_updated_gmt,
  i.last_status_update
  
FROM sierra_view.item_record i
JOIN sierra_view.circ_trans t
  ON i.id = t.item_record_id
  AND t.op_code IN ('o','i')
  AND t.transaction_gmt BETWEEN '2025-07-02 12:55:00' AND '2025-07-03 08:00:00'
JOIN sierra_view.record_metadata rm
  ON i.id = rm.id
  AND rm.record_last_updated_gmt BETWEEN '2025-07-02 12:55:00' AND '2025-07-03 08:00:00'
JOIN sierra_view.item_record_property ip
  ON i.id = ip.item_record_id
JOIN sierra_view.bib_record_item_record_link l
  ON i.id = l.item_record_id
JOIN bib_list bl
  ON l.bib_record_id = bl.id
  
ORDER BY rm.record_last_updated_gmt