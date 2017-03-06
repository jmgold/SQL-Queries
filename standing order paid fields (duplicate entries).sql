-- Custom report requested by arlington to gather paid field data for open standing orders with multiple payments
-- Produces 3 duplicate lines for each result for unknown reasons so requires deduping in excel

SELECT 
  order_view.record_num AS "Record_number",
  bib_record_property.best_title AS "title",
  order_record_paid.paid_date_gmt AS "paid_date", 
  order_record_paid.invoice_date_gmt AS "Invoice date", 
  order_record_paid.invoice_code AS "Invoice", 
  order_record_paid.paid_amount AS "paid amount", 
  order_record_paid.voucher_num AS "Voucher", 
  order_record_paid.copies AS "Copies", 
  order_record_paid.note AS "Note", 
  order_view.vendor_record_code AS "vendor",
  order_record_cmf.location_code AS "Location",
  order_view.order_status_code AS "Status",
  CAST(order_record_cmf.fund_code AS INTEGER) AS "fund code number",
  order_record_cmf.fund_code AS "fund",
  fund_master.code AS "fund code",
  fund_myuser.name AS "fund_name"
FROM   sierra_view.order_record_paid 
  JOIN sierra_view.order_view
     ON order_record_paid.order_record_id=order_view.record_id
  JOIN sierra_view.bib_record_order_record_link
     ON order_record_paid.order_record_id=bib_record_order_record_link.order_record_id
  JOIN sierra_view.order_record_cmf
     ON order_record_paid.order_record_id=order_record_cmf.order_record_id
  JOIN sierra_view.fund_master
     ON fund_master.code_num=CAST(order_record_cmf.fund_code AS INTEGER)
  JOIN sierra_view.fund_myuser
     ON fund_myuser.fund_code=fund_master.code
     AND fund_myuser.acct_unit = '2' 
  --LEFT OUTER JOIN sierra_view.fund_master
  --   ON order_record_cmf.fund_code::integer=fund_master.code_num
  LEFT OUTER JOIN sierra_view.bib_record_property
     ON bib_record_order_record_link.bib_record_id=bib_record_property.bib_record_id
WHERE 
  order_view.accounting_unit_code_num = '2' AND 
  order_view.order_type_code = 'o'
  
--
ORDER BY
order_view.record_num,
order_record_paid.invoice_date_gmt
