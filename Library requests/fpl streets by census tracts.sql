SELECT DISTINCT
  s.content AS census_tract,
  SPLIT_PART(a.addr1,' ',1) AS house_num,
  SPLIT_PART(a.addr1,' ',2) AS street,
  pc.name AS pcode4
  
FROM sierra_view.patron_record p
JOIN sierra_view.patron_record_address a
  ON p.id = a.patron_record_id
JOIN sierra_view.subfield s
  ON p.id = s.record_id
  AND s.field_type_code = 'k'
  AND s.tag = 't'
JOIN sierra_view.user_defined_pcode4_myuser pc
  ON p.pcode4::VARCHAR = pc.code

WHERE p.pcode3 = '36'

ORDER BY 1,3,2