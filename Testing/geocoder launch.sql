SELECT 
DISTINCT a.id,
a.street, 
a.city, 
a.region, 
a.zip

FROM (
SELECT 
p.patron_record_id AS id,
p.addr1 AS street,
REGEXP_REPLACE(REGEXP_REPLACE(p.city,'\d','','g'),'\sma$','','i') AS city,
CASE WHEN p.region = '' AND LOWER(p.city) ~ '\sma$' THEN 'MA' ELSE p.region END AS region,
SUBSTRING(p.postal_code,'^\d{5}') AS zip,
s.content,
--rm.creation_date_gmt,
pr.ptype_code

FROM sierra_view.patron_record_address p
JOIN sierra_view.record_metadata rm
ON p.patron_record_id = rm.id AND LOWER(p.addr1) !~ '^p\.?\s?o' AND p.patron_record_address_type_id = '1'
LEFT JOIN sierra_view.subfield s
ON p.patron_record_id = s.record_id  AND s.field_type_code = 'k' AND s.tag = 'd'
JOIN
sierra_view.patron_record pr
ON
p.patron_record_id = pr.id

WHERE s.content IS NULL --OR TO_DATE(s.content,'YYYY-MM-DD') <= (CURRENT_DATE - INTERVAL '1 YEAR')  

ORDER BY CASE 
WHEN pr.ptype_code = '8' THEN 1 
WHEN pr.ptype_code = '2' THEN 2
WHEN pr.ptype_code = '7' THEN 3 
WHEN pr.ptype_code = '6' THEN 4 
ELSE 5 END 

LIMIT 10000
) a
