-- Lost in transit report
--
-- Based on in transit query from Jason Boland
--
SELECT
  id2reckey(i.id)||'a' as rec_nuum, 
  SPLIT_PART(v.field_content, ' ', 9) as checkin_location,
  l.name as destination,
  id2reckey(i.id)||'a' as rec_num,
  to_date(SPLIT_PART(v.field_content, ' ', 3)||' '||SPLIT_PART(v.field_content, ' ', 2)||' '||SPLIT_PART(v.field_content, ' ', 4),'DD Mon YYYY') as checkin_date ,
  v.field_content 
FROM sierra_view.varfield_view v
JOIN sierra_view.item_view i ON v.record_id = i.id
JOIN sierra_view.iii_user u ON SPLIT_PART(v.field_content, ' ', 9) = u.name
JOIN sierra_view.location_myuser l ON SUBSTRING(SPLIT_PART(v.field_content, ' ', 11) FOR 3) = l.code
WHERE field_content LIKE '%TRANSIT%' AND i.item_status_code = 't' AND (to_date(SPLIT_PART(v.field_content, ' ', 3)||' '||SPLIT_PART(v.field_content, ' ', 2)||' '||SPLIT_PART(v.field_content, ' ', 4),'DD Mon YYYY') < now()::date-interval '30 days')
GROUP BY 1,2,3,4,5,6
ORDER BY 3,5;