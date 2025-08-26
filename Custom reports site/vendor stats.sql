/*
Jeremy Goldstein
Minuteman Library Network

Gathers various statistics such as copies ordered, avg prices and shipping time, when possible, for each vendor
Looks at a combination of order and payment/invoice data for calculations
Report is limited to completed order records, as they have all the fields required for the calculations within the report.
*/

WITH order_dates AS (
  SELECT
    DISTINCT o.id,
    p.invoice_date_gmt::DATE AS ship_date,
    p.paid_date_gmt::DATE AS paid_date,
    TO_DATE(SUBSTRING(sent.content, '\d{2}\-\d{2}\-\d{4}'),'MM-DD-YYYY') AS sent_date

  FROM sierra_view.order_record o
  JOIN sierra_view.record_metadata rm
    ON o.id = rm.id
  JOIN sierra_view.order_record_paid p
    ON o.id = p.order_record_id
  JOIN sierra_view.subfield sent
    ON o.id = sent.record_id
	 AND sent.field_type_code = 'b'
	 AND sent.tag = 'b'
	 AND TO_DATE(SUBSTRING(sent.content, '\d{2}\-\d{2}\-\d{4}'),'MM-DD-YYYY') IS NOT NULL

  WHERE o.accounting_unit_code_num = {{accounting_unit}}
	 AND rm.creation_date_gmt >= {{created_date}}::DATE
),

vendor_name AS (
  SELECT
    v.code AS vendor_code,
    STRING_AGG(DISTINCT n.field_content,', ') AS vendor_name
    
  FROM sierra_view.vendor_record v
  JOIN sierra_view.varfield n
    ON v.id = n.record_id
	 AND n.varfield_type_code = 't'
	 
  WHERE v.accounting_unit_code_num = {{accounting_unit}}
  GROUP BY 1
)

SELECT
  *,
  '' AS "VENDOR STATISTICS",
  '' AS "https://sic.minlib.net/reports/58"

FROM(
  SELECT
    vn.vendor_code,
    vn.vendor_name,
    SUM(cmf.copies) AS copies_ordered,
    COALESCE(SUM(p.copies),0) AS copies_received,
    COALESCE(SUM(cmf.copies) FILTER(WHERE o.order_status_code = 'z'),'0') - COALESCE(SUM(p.copies) FILTER(WHERE o.order_status_code = 'z'),0) AS copies_cancelled,
    COALESCE(SUM(p.paid_amount),'0')::MONEY AS total_paid,
    COALESCE(SUM(p.paid_amount)/SUM(p.copies),'0')::MONEY AS price_per_copy,
    COALESCE(ROUND(AVG(ship_date - sent_date))::VARCHAR,'') AS avg_days_to_ship,
    COALESCE(ROUND(AVG(paid_date - sent_date))::VARCHAR,'') AS avg_days_to_invoice

  FROM sierra_view.order_record o
  JOIN sierra_view.record_metadata rm
    ON o.id = rm.id
  JOIN vendor_name vn
    ON o.vendor_record_code = vn.vendor_code
  JOIN sierra_view.order_record_cmf cmf
    ON o.id = cmf.order_record_id
	 AND cmf.display_order = '0'
  LEFT JOIN sierra_view.order_record_paid p
    ON o.id = p.order_record_id
  LEFT JOIN order_dates od
    ON o.id = od.id

  WHERE o.accounting_unit_code_num = {{accounting_unit}}
	 AND rm.creation_date_gmt >= {{created_date}}::DATE
  GROUP BY 1,2

  UNION

  SELECT
    'TOTAL' AS vendor_code,
    '' AS vendor_name,
    SUM(cmf.copies) AS copies_ordered,
    SUM(p.copies) AS copies_received,
    SUM(cmf.copies) FILTER(WHERE o.order_status_code = 'z') - COALESCE(SUM(p.copies) FILTER(WHERE o.order_status_code = 'z'),0) AS copies_cancelled,
    SUM(p.paid_amount)::MONEY AS total_paid,
    (SUM(p.paid_amount)/SUM(p.copies))::MONEY AS price_per_copy,
    '' AS avg_days_to_ship,
    '' AS avg_days_to_invoice

  FROM sierra_view.order_record o
  JOIN sierra_view.record_metadata rm
    ON o.id = rm.id
  JOIN sierra_view.order_record_cmf cmf
    ON o.id = cmf.order_record_id
	 AND cmf.display_order = '0'
  LEFT JOIN sierra_view.order_record_paid p
    ON o.id = p.order_record_id
  LEFT JOIN order_dates od
    ON o.id = od.id

  WHERE o.accounting_unit_code_num = {{accounting_unit}}
	 AND rm.creation_date_gmt >= {{created_date}}::DATE
  GROUP BY 1,2
)a

ORDER BY CASE
	WHEN vendor_code = 'TOTAL' THEN 2
	ELSE 1
END,
vendor_code