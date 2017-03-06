--patron addresses limited to one ptype

SELECT 
  'p'||patron_view.record_num||'a' AS Pnumber, 
  patron_view.barcode, 
  patron_record_address.addr1, 
  patron_record_address.city,
  patron_record_address.region,
  patron_record_address.postal_code
FROM 
  sierra_view.patron_view 
JOIN
  sierra_view.patron_record_address
ON
  patron_record_address.patron_record_id=patron_view.id
WHERE 
  patron_view.ptype_code = '137';
