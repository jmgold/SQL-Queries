/*
Jeremy Goldstein
Minuteman Library Network
Gather statistics around billed item charges
*/

WITH bills AS (
  SELECT o.patron_record_id,
    i.id AS item_record_id
  FROM sierra_view.item_record i
  JOIN sierra_view.checkout o
    ON i.id = o.item_record_id
  WHERE i.item_status_code = 'n'
),

patron_totals AS (
  SELECT
    b.patron_record_id,
    SUM(f.item_charge_amt) AS total_charges
  FROM bills b
  LEFT JOIN sierra_view.fine f
    ON b.patron_record_id = f.patron_record_id
    AND b.item_record_id = f.item_record_metadata_id
  GROUP BY b.patron_record_id
),

patron_quintiles AS (
  SELECT
    patron_record_id,
    total_charges,
    NTILE(5) OVER (ORDER BY total_charges) AS quintile
  FROM patron_totals
)

SELECT
  --breaking out quintile 5 to separate out patrons over the $100 block limit
  CASE
    WHEN p.quintile = 5 AND pt.total_charges < 100 THEN 5
    WHEN p.quintile = 5 AND pt.total_charges >= 100 THEN 6
	 ELSE p.quintile
  END AS quintile,
  COUNT(DISTINCT p.patron_record_id) AS total_patrons,
  AVG(pt.total_charges)::MONEY AS avg_total_charges_per_patron,
  PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY pt.total_charges::MONEY) AS median_total_charges_per_patron,
  AVG(f.item_charge_amt)::MONEY AS avg_item_charge,
  PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY f.item_charge_amt::MONEY) AS median_item_charge,
  MODE() WITHIN GROUP (ORDER BY f.item_charge_amt::MONEY) AS mode_item_charge,
  MIN(pt.total_charges::MONEY) AS min_total_charge,
  MAX(pt.total_charges::MONEY) AS max_total_charge,
  COUNT(DISTINCT i.id) AS total_billed_items,
  ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'j') AS NUMERIC(12,2)))/COUNT(DISTINCT i.id),2)||'%' AS j_bills_pct,
  ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'y') AS NUMERIC(12,2)))/COUNT(DISTINCT i.id),2)||'%' AS ya_bills_pct,
  ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) NOT IN ('y','j')) AS NUMERIC(12,2)))/COUNT(DISTINCT i.id),2)||'%' AS ad_bills_pct,
  COUNT(DISTINCT pr.id) FILTER(WHERE pr.activity_gmt >= CURRENT_DATE - INTERVAL '12 months') AS active_6_months

FROM patron_quintiles p
JOIN sierra_view.patron_record pr
  ON p.patron_record_id = pr.id
LEFT JOIN bills b
  ON p.patron_record_id = b.patron_record_id
LEFT JOIN sierra_view.fine f
  ON b.patron_record_id = f.patron_record_id
  AND b.item_record_id = f.item_record_metadata_id
LEFT JOIN patron_totals pt
  ON p.patron_record_id = pt.patron_record_id
LEFT JOIN sierra_view.item_record i
  ON b.item_record_id = i.id
  
GROUP BY 1
ORDER BY 1