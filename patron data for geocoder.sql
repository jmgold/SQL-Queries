/*
Jeremy Goldstein
Minuteman Library Network

Gathers data for passing to census bureau geocoder batch api, with limit of 10,000 records per batch.
*/

SELECT
DISTINCT a.id,
a.street,
a.city,
a.region,
a.zip
FROM
(SELECT p.patron_record_id AS id,
p.addr1 AS street,
REGEXP_REPLACE(REGEXP_REPLACE(p.city,'\d','','g'),'\sma$','','i') AS city,
CASE WHEN p.region = '' AND LOWER(p.city) ~ '\sma$' THEN 'MA'
ELSE p.region END AS region,
SUBSTRING(p.postal_code,'^\d{5}') AS zip,
s.content,
rm.creation_date_gmt
FROM sierra_view.patron_record_address p
--JOIN sierra_view.patron_record pr
--ON p.patron_record_id = pr.id AND pr.ptype_code = '12'
JOIN sierra_view.record_metadata rm
ON p.patron_record_id = rm.id
AND LOWER(p.addr1) !~ '^p\.?\s?o' AND p.patron_record_address_type_id = '1'
LEFT JOIN sierra_view.subfield s
ON p.patron_record_id = s.record_id  AND s.field_type_code = 'k' AND s.tag = 'd'
WHERE s.content IS NULL OR TO_DATE(s.content,'YYYY-MM-DD') <= (CURRENT_DATE - INTERVAL '1 YEAR')
ORDER BY
CASE WHEN s.content IS NULL THEN 1 ELSE 2 END,
rm.creation_date_gmt) a
LIMIT 10000