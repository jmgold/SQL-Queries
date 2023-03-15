/*
Jeremy Goldstein
Minuteman Library Network

Retrieves metadata for deleted records
*/

SELECT 
  rm.record_type_code||rm.record_num||'a' AS record_number, 
  rm.deletion_date_gmt::DATE AS deletion_date, 
  rm.creation_date_gmt::DATE AS creation_date,
  rm.record_last_updated_gmt::DATE AS last_updated_date
  
FROM 
  sierra_view.record_metadata rm
  
WHERE 
  rm.deletion_date_gmt IS NOT NULL 
LIMIT 1000