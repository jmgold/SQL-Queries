SELECT DISTINCT id2reckey(a.id)||'a', a.street, a.city, a.region, a.zip 
FROM (
SELECT p.patron_record_id AS id,
COALESCE(p.addr1,'') AS street,
COALESCE(CASE 
  WHEN p.city IS NOT NULL THEN REGEXP_REPLACE(TRIM(p.city),'\s[a-zA-Z]{2}\s?(\d{5,})?\s?\-?\s?(\d{4,})?$','')
  WHEN p.city IS NULL AND p.addr1 ~ '\y([A-Za-z]+),?\s[A-Za-z]{2}(?:\s?\d{5,})?$' THEN (REGEXP_MATCH(TRIM(p.addr1), '\y([A-Za-z]+),?\s[A-Za-z]{2}(?:\s?\d{5,})?$'))[1]
END,'') AS city,
COALESCE(CASE WHEN p.region = '' AND (LOWER(p.city) ~ '\sma$' OR pr.pcode3 BETWEEN '1' AND '200') THEN 'MA'
  WHEN p.region IS NULL AND p.city IS NULL AND TRIM(p.addr1) ~ '^.*\s(ma|Ma|mA|MA)(\s\d{5,})|$' THEN 'MA' 
  ELSE REGEXP_REPLACE(p.region,'\d|\-|\s','','g') END,'') AS region,
COALESCE(CASE WHEN p.postal_code IS NULL AND TRIM(p.region) ~ '(MA)?\s?\d{5}' THEN SUBSTRING(TRIM(p.region),'\d{5,9}\s?\-?\s?\d{0,4}')
  WHEN p.postal_code IS NULL AND p.region = '' AND p.city ~ '(MA)?\s?\d{5}' THEN SUBSTRING(TRIM(p.city),'\d{5,9}\s?\-?\s?\d{0,4}$')
  WHEN p.postal_code IS NULL AND p.region IS NULL AND p.city IS NULL AND p.addr1 ~ '(MA)?\s?\d{5}' THEN SUBSTRING(TRIM(p.addr1),'\d{5,9}\s?\-?\s?\d{0,4}$')
  ELSE SUBSTRING(p.postal_code,'^\d{5}') END,'') AS zip,
s.content,
rm.creation_date_gmt, 
pr.ptype_code 
FROM sierra_view.patron_record_address p 
JOIN sierra_view.record_metadata rm 
ON p.patron_record_id = rm.id AND LOWER(p.addr1) !~ '^p\.?\s?o' AND p.patron_record_address_type_id = '1' 
LEFT JOIN sierra_view.subfield s 
ON p.patron_record_id = s.record_id  AND s.field_type_code = 'k' AND s.tag = 'd' 
JOIN sierra_view.patron_record pr 
ON p.patron_record_id = pr.id 
WHERE ((s.content IS NULL OR s.content !~ '^\d{4}\-\d{2}\-\d{2}$') AND pr.ptype_code NOT IN ('43','199','204','205','206','207','254')) OR TO_DATE(SUBSTRING(REGEXP_REPLACE(s.content,'[^0-9\-]','','g'),1,10),'YYYY-MM-DD') < rm.record_last_updated_gmt::DATE
/*
Used when conducting a full update of patron records
pr.ptype_code NOT IN ('43','199','204','205','206','207','254')
AND pr.ptype_code IN ('1','3','4')
*/
--AND p.addr1 != '' AND p.city != ''
ORDER BY CASE WHEN s.content IS NULL THEN 1 ELSE 2 END, s.content 
) a WHERE a.zip = '' OR a.region = '' OR a.city = ''