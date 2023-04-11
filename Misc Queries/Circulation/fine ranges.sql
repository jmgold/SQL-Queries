/* 
Jeremy Goldstein
Minuteman Library Network

Gathers stats around fines owed, broken into ranges of total owed
Based upon query from Jason Boland
*/

SELECT
  l.name AS loc,
  amt.start_charge::MONEY AS "Start Charge",
  amt.end_charge::MONEY AS "End Charge",
  SUM((f.item_charge_amt+f.processing_fee_amt+f.billing_fee_amt)::MONEY) AS "Total Due",
  COUNT(f.patron_record_id) AS total_patrons,
  (SUM((f.item_charge_amt+f.processing_fee_amt+f.billing_fee_amt)::MONEY))/COUNT(f.patron_record_id) AS avg_fine_per_patron,
  DATE_TRUNC('day', AVG(AGE(CURRENT_DATE,activity_gmt::DATE))) AS avg_last_active
  
FROM 
sierra_view.fine f
JOIN ( 
	SELECT 0.00 AS start_charge, 9.99 AS end_charge UNION 
   SELECT 10.00 AS start_charge, 50.00 AS end_charge UNION 
   SELECT 50.01 AS start_charge, 100.00 AS end_charge UNION 
   SELECT 100.01 AS start_charge, 200.00 AS end_charge UNION 
   SELECT 200.01 AS start_charge, 300.00 AS end_charge UNION 
   SELECT 300.01 AS start_charge, 400.00 AS end_charge UNION 
   SELECT 400.01 AS start_charge, 500.00 AS end_charge UNION 
   SELECT 500.01 AS start_charge, 600.00 AS end_charge UNION 
   SELECT 600.01 AS start_charge, 700.00 AS end_charge UNION 
   SELECT 700.01 AS start_charge, 800.00 AS end_charge UNION 
   SELECT 800.01 AS start_charge, 900.00 AS end_charge UNION 
   SELECT 900.01 AS start_charge, 1000.00 AS end_charge UNION 
   SELECT 1000.01 AS start_charge, 1100.00 AS end_charge UNION 
   SELECT 1100.01 AS start_charge, 1200.00 AS end_charge UNION 
   SELECT 1200.01 AS start_charge, 9999.99 AS end_charge) as amt
ON (f.item_charge_amt+f.processing_fee_amt+f.billing_fee_amt) BETWEEN amt.start_charge AND amt.end_charge
JOIN
sierra_view.patron_record p 
ON
f.patron_record_id = p.id
JOIN
sierra_view.location_myuser l
ON
SUBSTRING(f.charge_location_code for 3) = SUBSTRING(l.code FOR 3) AND l.code ~ '^[a-z1-9]{3}$'

GROUP BY loc, amt.start_charge, amt.end_charge
ORDER BY 1,amt.start_charge;