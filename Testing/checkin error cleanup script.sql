SELECT
  ip.barcode,
  si.name AS username,
  si.code AS checkin_stat_group_code,
  i.checkout_statistic_group_code_num AS checkout_stat_group_code,
  so.name AS checkout_stat_group_name,
  v.field_content AS message,
  o.checkout_gmt AS checkout_time,
  TO_TIMESTAMP(SPLIT_PART(v.field_content,': IN',1), 'Dy Mon DD YYYY  HH:MIAM') AS checkin_time,
  SPLIT_PART(SPLIT_PART(v.field_content,'from ',2),' to',1) AS origin_loc,
  SPLIT_PART(v.field_content,'to ',2) AS destination_loc,
  CASE
    WHEN h.id IS NOT NULL THEN true
	 ELSE FALSE
  END AS fulfilling_hold
  
FROM sierra_view.item_record i
JOIN sierra_view.checkout o
  ON i.id = o.item_record_id
JOIN sierra_view.varfield v
  ON i.id = v.record_id
  AND v.varfield_type_code = 'm'
  AND v.field_content LIKE '%IN TRANSIT%'
JOIN sierra_view.item_record_property ip
  ON i.id = ip.item_record_id
JOIN sierra_view.statistic_group_myuser so
  ON i.checkout_statistic_group_code_num = so.code
JOIN sierra_view.statistic_group_myuser si
  ON SPLIT_PART(SPLIT_PART(v.field_content,'from ',2),' to',1) = si.name
LEFT JOIN sierra_view.hold h
  ON i.id = h.record_id

WHERE i.item_status_code IN ('t')
AND EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - TO_TIMESTAMP(SPLIT_PART(v.field_content,': IN',1), 'Dy Mon DD YYYY  HH:MIAM'))) > 120

ORDER BY TO_TIMESTAMP(SPLIT_PART(v.field_content,': IN',1), 'Dy Mon DD YYYY  HH:MIAM')