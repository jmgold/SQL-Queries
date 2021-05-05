SELECT
SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,11) AS tract,
t.icode1 AS scat,
COUNT(DISTINCT t.id) AS checkout_total

FROM
sierra_view.circ_trans t
JOIN
sierra_view.patron_record p
ON
t.patron_record_id = p.id AND t.op_code = 'o' AND t.item_location_code ~ '^ca' AND t.transaction_gmt::DATE >= CURRENT_DATE - INTERVAL '1 month'
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id
AND LOWER(a.addr1) !~ '^p\.?\s?o'
AND a.patron_record_address_type_id = '1'
LEFT JOIN sierra_view.varfield v 
ON v.record_id = p.id AND v.varfield_type_code = 'k' AND v.field_content ~ '^\|s\d{2}' 

GROUP BY 1,2
ORDER BY 1,2