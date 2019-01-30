SELECT
    SUBSTRING(f.charge_location_code for 3) as loc,
  CAST((amt.start_charge) as money) AS "Start Charge",
  CAST((amt.end_charge) as money) AS "End Charge",
  SUM( CAST((f.item_charge_amt+f.processing_fee_amt+f.billing_fee_amt) AS money)) AS "Total Due",
  COUNT(f.patron_record_id) as total_patrons,
  (SUM( CAST((f.item_charge_amt+f.processing_fee_amt+f.billing_fee_amt) AS money)))/COUNT(f.patron_record_id) avg_fine_per_patron,
  AVG(AGE(now(),activity_gmt::date)) AS avg_last_active
  
FROM 
  sierra_view.fine f
  JOIN ( SELECT 0.00 as start_charge, 10.00 as end_charge UNION 
    SELECT 10.01 as start_charge, 50.00 as end_charge UNION 
    SELECT 50.01 as start_charge, 100.00 as end_charge UNION 
    SELECT 100.01 as start_charge, 200.00 as end_charge UNION 
    SELECT 200.01 as start_charge, 300.00 as end_charge UNION 
    SELECT 300.01 as start_charge, 400.00 as end_charge UNION 
    SELECT 400.01 as start_charge, 500.00 as end_charge UNION 
    SELECT 500.01 as start_charge, 600.00 as end_charge UNION 
    SELECT 600.01 as start_charge, 700.00 as end_charge UNION 
    SELECT 700.01 as start_charge, 800.00 as end_charge UNION 
    SELECT 800.01 as start_charge, 900.00 as end_charge UNION 
    SELECT 900.01 as start_charge, 1000.00 as end_charge UNION 
    SELECT 1000.01 as start_charge, 1100.00 as end_charge UNION 
    SELECT 1100.01 as start_charge, 1200.00 as end_charge UNION 
    SELECT 1200.01 as start_charge, 9999.99 as end_charge) as amt
  ON (f.item_charge_amt+f.processing_fee_amt+f.billing_fee_amt) BETWEEN amt.start_charge AND amt.end_charge
JOIN sierra_view.patron_record p ON f.patron_record_id = p.id
GROUP BY loc, amt.start_charge, amt.end_charge
ORDER BY 1,amt.start_charge;