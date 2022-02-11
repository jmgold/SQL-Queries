SELECT 
TO_DATE(SUBSTRING(s.content,1,10),'YYYY-MM-DD'),
COUNT(distinct p.patron_record_id)

FROM sierra_view.patron_record_address p 
JOIN sierra_view.record_metadata rm 
ON p.patron_record_id = rm.id AND LOWER(p.addr1) !~ '^p\.?\s?o' AND p.patron_record_address_type_id = '1' 
LEFT JOIN sierra_view.subfield s 
ON p.patron_record_id = s.record_id  AND s.field_type_code = 'k' AND s.tag = 'd' 
JOIN sierra_view.patron_record pr 
ON p.patron_record_id = pr.id 
WHERE pr.ptype_code NOT IN ('43','199','204','205','206','207','254')
--AND p.addr1 != '' AND p.city != ''
GROUP BY 1
ORDER BY 1 desc
