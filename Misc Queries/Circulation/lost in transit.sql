/*Lost in transit report

Jeremy Goldstein
Minuteman Library Network
Based on in transit query from Jason Boland
*/

SELECT
  rm.record_type_code||rm.record_num||'a' AS item_number, 
  l2.name AS checkin_location,
  l.name AS destination,
  to_date(SPLIT_PART(v.field_content, ' ', 3)||' '||SPLIT_PART(v.field_content, ' ', 2)||' '||SPLIT_PART(v.field_content, ' ', 4),'DD Mon YYYY') AS checkin_date
  
FROM sierra_view.item_record i
JOIN sierra_view.varfield v
ON i.id = v.record_id AND v.varfield_type_code = 'm' AND v.field_content LIKE '%TRANSIT%' AND i.item_status_code = 't'
JOIN sierra_view.record_metadata rm
ON i.id = rm.id
JOIN sierra_view.location_myuser l
ON SUBSTRING(SPLIT_PART(v.field_content, ' ', 11) FOR 3) = l.code
JOIN
sierra_view.location_myuser l2
ON SUBSTRING(SPLIT_PART(v.field_content, ' ', 9) FOR 3) = l2.code

WHERE (TO_DATE(SPLIT_PART(v.field_content, ' ', 3)||' '||SPLIT_PART(v.field_content, ' ', 2)||' '||SPLIT_PART(v.field_content, ' ', 4),'DD Mon YYYY') < CURRENT_DATE - INTERVAL '30 days')

ORDER BY 3,4;