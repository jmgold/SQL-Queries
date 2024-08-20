SELECT
--SUBSTRING(a.postal_code,'^\d{5}') AS zip,

CASE 
	WHEN v.field_content IS NULL THEN 'no data' 
	WHEN v.field_content = '' THEN v.field_content 
	ELSE SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,12) 
   END AS geoid, 
l.name AS owning_library,
COUNT(ct.id) AS checkout_total

FROM
sierra_view.circ_trans ct
JOIN
sierra_view.patron_record p
ON
ct.patron_record_id = p.id
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id
AND LOWER(a.addr1) !~ '^p\.?\s?o'
AND a.patron_record_address_type_id = '1'
LEFT JOIN sierra_view.varfield v 
ON v.record_id = p.id AND v.varfield_type_code = 'k' AND v.field_content ~ '^\|s\d{2}' 
JOIN
sierra_view.item_record i
ON
ct.item_record_id = i.id
JOIN
sierra_view.location_myuser l
ON
SUBSTRING(i.location_code,1,3) = l.code

WHERE ct.op_code = 'o'

GROUP BY 1,2
ORDER BY 1,2