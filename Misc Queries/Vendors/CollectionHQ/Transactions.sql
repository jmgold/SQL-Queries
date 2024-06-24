/*
Jeremy Goldstein
Minuteman Library Network

Gathers transactions (limited to those associated with a location)
for a regular data upload to CollectionHQ
*/

SELECT
  ip.barcode,
  CASE
    WHEN (t.stat_group_code_num BETWEEN '530' AND '539') OR (t.stat_group_code_num BETWEEN '551' AND '561') OR t.stat_group_code_num = '0' THEN t.stat_group_code_num::VARCHAR
    ELSE 'Not Morse Transaction'
  END AS transaction_stat_group,
  CASE
    WHEN t.item_location_code ~ '^na[^2]' THEN t.item_location_code
    WHEN t.item_location_code = '' THEN NULL
    ELSE 'Not Morse Item'
  END AS item_location,
  CASE
    WHEN o.id IS NOT NULL THEN 'CHECKED OUT'
    ELSE status.name
  END AS item_status,
  t.transaction_gmt::DATE AS transaction_date,
  CASE
    WHEN t.op_code = 'o' THEN 'CHECKOUT'
    WHEN t.op_code = 'i' THEN 'CHECKIN'
    WHEN t.op_code = 'f' THEN 'FILLED HOLD'
    WHEN t.op_code = 'r' THEN 'RENEWAL'
    WHEN t.op_code = 'u' THEN 'INTERNAL USE COUNT'
  END AS transaction_type,
  rmi.record_type_code||rmi.record_num AS item_record_num,
  rmb.record_type_code||rmb.record_num AS bib_record_num,
  pt.name AS patron_type
  
FROM sierra_view.circ_trans t
LEFT JOIN sierra_view.item_record i
  ON t.item_record_id = i.id AND i.location_code ~ '^na[^2]'
LEFT JOIN sierra_view.item_record_property ip
  ON i.id = ip.item_record_id
JOIN sierra_view.statistic_group_myuser sg
  ON t.stat_group_code_num = sg.code AND t.op_code !~ '^(n|h)'
JOIN sierra_view.ptype_property_myuser pt
  ON t.ptype_code = pt.value::VARCHAR
LEFT JOIN sierra_view.item_status_property_myuser status
  ON i.item_status_code = status.code
LEFT JOIN sierra_view.checkout o
  ON i.id = o.item_record_id
LEFT JOIN sierra_view.record_metadata rmi
  ON t.item_record_id = rmi.id
LEFT JOIN sierra_view.record_metadata rmb
  ON t.bib_record_id = rmb.id

WHERE (t.stat_group_code_num BETWEEN '530' AND '539') OR (t.stat_group_code_num BETWEEN '551' AND '561') OR i.location_code ~ '^na[^2]'
    AND t.transaction_gmt::DATE >= CURRENT_DATE - INTERVAL '1 WEEK'
ORDER BY 5
  
