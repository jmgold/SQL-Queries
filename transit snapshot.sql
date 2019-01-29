-- In transit report
--
-- Based on query from Jason Boland
--
SELECT 
  u.iii_user_group_code,  
  l.name,
  COUNT(v.field_content) AS "Count"  
FROM sierra_view.varfield_view v
JOIN sierra_view.item_view i ON v.record_id = i.id
JOIN sierra_view.iii_user u ON SPLIT_PART(v.field_content, ' ', 9) = u.name
JOIN sierra_view.location_myuser l ON SUBSTRING(SPLIT_PART(v.field_content, ' ', 11) FOR 3) = l.code
WHERE field_content LIKE '%TRANSIT%' AND i.item_status_code = 't'
GROUP BY 1,2
ORDER BY 1,2;