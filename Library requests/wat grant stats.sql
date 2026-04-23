SELECT 
 ENCODE(SHA256(t.patron_record_id::VARCHAR::BYTEA||rmp.record_num::VARCHAR::BYTEA||TO_CHAR(rmp.creation_date_gmt,'dayMonDD YYYY SS')::BYTEA),'hex') AS user,
 t.transaction_gmt::DATE AS checkout_date
 
FROM sierra_view.circ_trans t
JOIN sierra_view.record_metadata rmi
  ON t.item_record_id = rmi.id
JOIN sierra_view.record_metadata rmp
  ON t.patron_record_id = rmp.id
  
WHERE t.op_code = 'o'
  AND rmi.record_type_code||rmi.record_num IN 
    (
    '',
    '',
    '',
    '',
    ''
    )
