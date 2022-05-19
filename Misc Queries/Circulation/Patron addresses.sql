/*
Jeremy Goldstein
Minuteman Library Network

Retrieves the mailing addresses for all patrons with a specified ptype
and performs some data cleanup on the city/state/zip fields to catch some common data entry errors
*/

SELECT 
rm.record_type_code||rm.record_num||'a' AS pnumber
,COALESCE(a.addr1,'') AS street 
,COALESCE(REGEXP_REPLACE(REGEXP_REPLACE(a.city,'\d','','g'),'\sma$','','i'),'') AS city
,COALESCE(CASE WHEN a.region = '' AND (LOWER(a.city) ~ '\sma$' OR p.pcode3 BETWEEN '1' AND '200') THEN 'MA' ELSE a.region END,'') AS state
,COALESCE(SUBSTRING(a.postal_code,'^\d{5}'),'') AS zip
  
FROM 
sierra_view.patron_record p 
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id

WHERE 
p.ptype_code = '137'
