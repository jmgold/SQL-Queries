/*
Jeremy Goldstein
Minuteman Library Network

Retrieves the line item details for an invoice and breaks out additional charges to each line item. 
*/

SELECT
*,
'' AS "INVOICE LINE ITEMS",
'' AS "https://sic.minlib.net/reports/117"
FROM
(
  SELECT 
    CASE
      WHEN il.order_record_metadata_id IS NOT NULL THEN id2reckey(il.order_record_metadata_id)||'a'
	   ELSE 'x-record'
    END AS order_number,
    i.invoice_number_text AS invoice_number,
    id2reckey(i.id)||'a' AS invoice_record_number,
    i.invoice_date_gmt::DATE AS invoice_date,
    i.paid_date_gmt::DATE AS paid_date,
    o.order_date_gmt::DATE AS order_date,
    COALESCE(il.title,il.note) AS title,
    COALESCE(il.copies_paid_cnt, '1') AS copies,
    il.paid_amt::MONEY AS line_item_charge,
    --using NULLIF logic to account for outlying case where subtotal = 0
    (i.discount_amt * (il.paid_amt / NULLIF(SUM(i.subtotal_amt),0)))::MONEY AS service_charge,
    (i.shipping_amt * (il.paid_amt / NULLIF(SUM(i.subtotal_amt),0)))::MONEY AS shipping_charge,
    (COALESCE(i.total_tax_amt,0) * (il.paid_amt / NULLIF(SUM(i.subtotal_amt),0)))::MONEY AS tax,
    ((i.discount_amt * (il.paid_amt / NULLIF(SUM(i.subtotal_amt),0))) + (i.shipping_amt * (il.paid_amt / NULLIF(SUM(i.subtotal_amt),0))) + (COALESCE(i.total_tax_amt,0) * (il.paid_amt / NULLIF(SUM(i.subtotal_amt),0))))::MONEY AS total_additional_charges,
    (il.paid_amt + (i.discount_amt * (il.paid_amt / NULLIF(SUM(i.subtotal_amt),0))) + (i.shipping_amt * (il.paid_amt / NULLIF(SUM(i.subtotal_amt),0))) + (COALESCE(i.total_tax_amt,0) * (il.paid_amt / NULLIF(SUM(i.subtotal_amt),0))))::MONEY AS total_paid,
    fm.code AS fund,
    il.vendor_code AS vendor
  
  FROM sierra_view.invoice_record i
  JOIN sierra_view.invoice_record_line il
    ON i.id = il.invoice_record_id
  JOIN sierra_view.accounting_unit a
    ON i.accounting_unit_code_num = {{accounting_unit}}
    AND a.code_num = {{accounting_unit}}
  JOIN sierra_view.fund_master fm
    ON il.fund_code::INT = fm.code_num
    AND a.id = fm.accounting_unit_id
  LEFT JOIN sierra_view.record_metadata rm
    ON i.id = rm.id
  LEFT JOIN sierra_view.order_record o
    ON il.order_record_metadata_id = o.id

  WHERE {{date_field}} BETWEEN {{start_date}}::DATE AND {{end_date}}::DATE
	--i.paid_date_gmt or i.invoice_date_gmt
  GROUP BY 1,2,3,4,5,6,7,8,9,15,16,i.discount_amt,il.paid_amt,i.shipping_amt,i.total_tax_amt,i.invoice_date_gmt, i.paid_date_gmt,il.line_cnt

  ORDER BY i.invoice_date_gmt, i.invoice_number_text, il.line_cnt
)a