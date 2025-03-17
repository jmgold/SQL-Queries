/*
Jeremy Goldstein
Minuteman Library Network

Identify items that are simultaneously checked out and in transit or on a hold shelf.
Caused by a self check session being left open when a patron immediately returns an unwanted item
*/
SELECT
  rm.record_type_code||rm.record_num||'a' AS record_num,
  i.item_status_code,
  o.checkout_gmt AS checkout_time,
  i.checkout_statistic_group_code_num AS checkout_stat_group_code,
  so.name AS checkout_stat_group_name,
  v.field_content AS message,
  SPLIT_PART(v.field_content,': IN',1) AS checkin_time,
  SPLIT_PART(SPLIT_PART(v.field_content,'from ',2),' to',1) AS origin_loc,
  SUBSTRING(SPLIT_PART(v.field_content,'to ',2) FROM 1 FOR 3) AS destination_loc
  
FROM sierra_view.item_record i
JOIN sierra_view.checkout o
  ON i.id = o.item_record_id
JOIN sierra_view.record_metadata rm
  ON i.id = rm.id
JOIN sierra_view.statistic_group_myuser so
  ON i.checkout_statistic_group_code_num = so.code
LEFT JOIN sierra_view.varfield v
  ON i.id = v.record_id
  AND v.varfield_type_code = 'm'
  AND v.field_content LIKE '%IN TRANSIT%'

WHERE i.item_status_code IN ('t','!')

ORDER BY 3