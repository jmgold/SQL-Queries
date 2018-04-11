--Jeremy Goldstein
--Minuteman Library Network

--Retrieves deleted records

SELECT 
  record_metadata.record_num, 
  record_metadata.deletion_date_gmt, 
  record_metadata.record_type_code 
FROM 
  sierra_view.record_metadata 
WHERE 
  record_metadata.record_type_code = 'b' AND 
  record_metadata.deletion_date_gmt IS NOT NULL 
  limit 100;
