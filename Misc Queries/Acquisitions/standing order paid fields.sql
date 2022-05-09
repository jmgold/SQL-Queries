/*
Jeremy Goldstein
Minuteman Library Network
Custom report requested by arlington to gather paid field data for open standing orders
sorted by record number to quickly identify titles with multiple payments
*/

SELECT 
  rm.record_type_code||rm.record_num||'a' AS record_number,
  b.best_title AS title,
  p.paid_date_gmt::DATE AS paid_date, 
  p.invoice_date_gmt::DATE AS invoice_date, 
  p.invoice_code AS invoice, 
  p.paid_amount::MONEY, 
  p.voucher_num AS voucher, 
  p.copies, 
  p.note, 
  o.vendor_record_code AS vendor,
  cmf.location_code,
  o.order_status_code,
  fm.code AS fund_code,
  fn.name AS fund_name
  
FROM   
sierra_view.order_record_paid p
JOIN 
sierra_view.order_record o
ON 
p.order_record_id = o.id
JOIN
sierra_view.record_metadata rm
ON
o.id = rm.id
JOIN
sierra_view.bib_record_order_record_link l
ON
p.order_record_id = l.order_record_id
JOIN
sierra_view.order_record_cmf cmf
ON
p.order_record_id = cmf.order_record_id AND cmf.location_code != 'multi'
JOIN
sierra_view.accounting_unit a
ON
o.accounting_unit_code_num = a.code_num
JOIN
sierra_view.fund_master fm
ON
fm.code_num = cmf.fund_code::INT AND fm.accounting_unit_id = a.id
JOIN
sierra_view.fund f
ON
fm.code = f.fund_code AND f.fund_type = 'fbal'
JOIN
sierra_view.fund_property fp
ON
fm.id = fp.fund_master_id AND fp.fund_type_id = '1'
JOIN
sierra_view.fund_property_name fn
ON
fp.id = fn.fund_property_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
     
WHERE o.accounting_unit_code_num = '2' AND o.order_type_code = 'o'

ORDER BY
rm.record_type_code||rm.record_num,
p.invoice_date_gmt
