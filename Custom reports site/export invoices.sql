/*
Jeremy Goldstein
Minuteman Library Network

Exports basic invoice data that cannot be easily extracted from within Sierra
*/


SELECT
*,
'' AS "INVOICE EXPORT",
'' AS "https://sic.minlib.net/reports/118"
FROM
(
  SELECT
    rm.record_type_code||rm.record_num||'a' AS record_num,
    i.invoice_number_text AS invoice_number,
    rm.creation_date_gmt::DATE AS creation_date,
    i.invoice_date_gmt::DATE AS invoice_date,
    i.paid_date_gmt::DATE AS paid_date,
    i.posted_data_gmt::DATE AS posted_date,
    i.subtotal_amt::MONEY AS subtotal_amt,
    i.shipping_amt::MONEY AS shipping_amt,
    i.total_tax_amt::MONEY AS tax_amt,
    i.discount_amt::MONEY AS service_charge_amt,
    i.grand_total_amt::MONEY AS grand_total_amt,
    STRING_AGG(DISTINCT il.vendor_code,', ') AS vendors,
    STRING_AGG(DISTINCT fm.code,', ' ORDER BY fm.code) AS funds,
    COUNT(il.id) AS line_items,
    SUM(il.copies_paid_cnt) AS copies_paid,
    CASE
      WHEN i.iii_user_name IS NULL THEN 'imported'
      ELSE 'manual'
    END AS creation_method,
    --null user indicates in imported invoice
    CASE
      WHEN i.status_code = 's' THEN 'suspended'
      WHEN i.status_code = 'f' THEN 'ready to post'
      WHEN i.status_code = '1' THEN 'post step 1'
      WHEN i.status_code = '2' THEN 'post step 2'
      WHEN i.status_code = '3' THEN 'post step 3'
      WHEN i.status_code = '4' THEN 'post step 4'
      WHEN i.status_code = '5' THEN 'post step 5'
      WHEN i.status_code = '6' THEN 'post step 6'
      WHEN i.status_code = 'c' THEN 'complete'
      ELSE ''
    END AS status
  
  FROM sierra_view.invoice_record i
  JOIN sierra_view.accounting_unit a
    ON i.accounting_unit_code_num = {{accounting_unit}}
    AND a.code_num = {{accounting_unit}}
  JOIN sierra_view.record_metadata rm
    ON i.id = rm.id
  JOIN sierra_view.invoice_record_line il
    ON i.id = il.invoice_record_id
  JOIN sierra_view.fund_master fm
    ON il.fund_code::INT = fm.code_num
    AND a.id = fm.accounting_unit_id

  WHERE {{date_field}} BETWEEN {{start_date}}::DATE AND {{end_date}}::DATE
	 --i.paid_date_gmt or i.invoice_date_gmt

  GROUP BY 1,2,3,4,5,6,7,8,9,10,11,16,17
)a