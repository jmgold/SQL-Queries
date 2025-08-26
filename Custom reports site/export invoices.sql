/*
Jeremy Goldstein
Minuteman Library Network

Exports basic invoice data that cannot be easily extracted from within Sierra
*/

SELECT
  rm.record_type_code||rm.record_num||'a' AS record_num,
  i.invoice_number_text AS invoice_number,
  rm.creation_date_gmt::DATE AS creation_date,
  i.invoice_date_gmt::DATE AS invoice_date,
  i.paid_date_gmt::DATE AS paid_date,
  i.posted_data_gmt::DATE AS posted_date,
  i.iii_user_name,
  --null user indicates in imported invoice
  i.subtotal_amt::MONEY,
  i.shipping_amt::MONEY,
  i.total_tax_amt::MONEY,
  i.discount_amt::MONEY AS service_charge_amt,
  i.grand_total_amt::MONEY,
  STRING_AGG(DISTINCT il.vendor_code,', ') AS vendors,
  STRING_AGG(DISTINCT fm.code,', ' ORDER BY fm.code) AS funds,
  COUNT(il.id) AS line_items,
  SUM(il.copies_paid_cnt) AS copies_paid
  

FROM sierra_view.invoice_record i
JOIN sierra_view.record_metadata rm
  ON i.id = rm.id
JOIN sierra_view.invoice_record_line il
  ON i.id = il.invoice_record_id
JOIN sierra_view.accounting_unit a
  ON i.accounting_unit_code_num = 7 --{accounting_unit}
  AND a.code_num = 7 --{accounting_unit}
JOIN sierra_view.fund_master fm
  ON il.fund_code::INT = fm.code_num
  AND a.id = fm.accounting_unit_id

WHERE i.accounting_unit_code_num = 7 --{accounting_unit}
  AND rm.creation_date_gmt > '2025-07-01'::DATE

GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12

LIMIT 200