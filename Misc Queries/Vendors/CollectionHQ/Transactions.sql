SELECT
  ip.barcode,
  CASE
    WHEN t.stat_group_code_num BETWEEN '530' AND '561' THEN sg.name
    WHEN t.stat_group_code_num = '0' THEN NULL
    ELSE 'Other'
  END AS checkout_location,
  CASE
    WHEN t.ptype_code IN ('26','42','43','126','200','201','202','203','204','205','206','207','326') THEN pt.name
	 ELSE 'Other'
  END AS patron_type,
  CASE
    WHEN t.item_location_code ~ '^na' THEN t.item_location_code
    WHEN t.item_location_code = '' THEN NULL
    ELSE 'OTHER'
  END AS item_location,
  CASE
    WHEN o.id IS NOT NULL THEN 'CHECKED OUT'
    ELSE status.name
  END AS status,
  t.transaction_gmt AS transaction_date,
  CASE
    WHEN t.op_code = 'o' THEN 'CHECKOUT'
    WHEN t.op_code = 'i' THEN 'CHECKIN'
    WHEN t.op_code = 'f' THEN 'FILLED HOLD'
    WHEN t.op_code = 'r' THEN 'RENEWAL'
    WHEN t.op_code = 'u' THEN 'INTERNAL USE COUNT'
  END AS transaction_type
  
FROM sierra_view.circ_trans t
LEFT JOIN sierra_view.item_record i
  ON t.item_record_id = i.id AND i.location_code ~ '^na'
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

WHERE t.stat_group_code_num BETWEEN '530' AND '561' OR i.location_code ~ '^na'

ORDER BY 6
  
