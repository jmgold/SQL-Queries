SELECT
invoice_view.invoice_number_text AS "INVOICE",
DATE(invoice_view.posted_date_gmt)AS "POSTED",
CONCAT(fund_master.code,'/',fund_property_name.name)AS "FUNDINFO",
invoice_record_line.title AS "Item Description",
invoice_record_line.copies_paid_cnt AS "QTY",
invoice_record_line.paid_amt AS "Expended",
invoice_view.grand_total_amt AS "INVOICE AMT",
  invoice_record_vendor_summary.voucher_num,
CAST(invoice_view.paid_date_gmt as date) AS "PAID DATE"
 
FROM
  sierra_view.invoice_record_vendor_summary
  JOIN sierra_view.invoice_view ON invoice_view.id = invoice_record_vendor_summary.invoice_record_id
  JOIN sierra_view.invoice_record_line ON invoice_record_line.invoice_record_vendor_summary_id = invoice_record_vendor_summary.id
  JOIN sierra_view.fund_master ON CAST(invoice_record_line.fund_code as integer) = fund_master.code_num
  JOIN sierra_view.fund_property ON fund_master.id = fund_property.fund_master_id
  JOIN sierra_view.fund_property_name ON fund_property.id = fund_property_name.fund_property_id
     AND fund_type_id=1
     AND iii_language_id=1
     AND posted_date_gmt BETWEEN '2016-01-18' AND '2016-01-22'
 
ORDER BY
fund_property_name.name
limit 100
;