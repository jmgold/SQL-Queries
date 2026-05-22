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
)

SELECT
  COUNT(DISTINCT b.patron_record_id) AS total_patrons_with_bills,
  ROUND(100.0 * (CAST(COUNT(DISTINCT b.patron_record_id) AS NUMERIC(12,2)) / CAST(COUNT(p.id) AS NUMERIC(12,2))), 4) || '%' AS pct_patrons_with_bills,
  AVG(pt.total_charges)::MONEY AS avg_total_charges_per_patron,
  PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY pt.total_charges::MONEY) AS median_total_charges_per_patron,
  AVG(f.item_charge_amt)::MONEY AS avg_item_charge,
  PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY f.item_charge_amt::MONEY) AS median_item_charge,
  MODE() WITHIN GROUP (ORDER BY f.item_charge_amt::MONEY) AS mode_item_charge

FROM sierra_view.patron_record p
LEFT JOIN bills b
  ON p.id = b.patron_record_id
LEFT JOIN sierra_view.fine f
  ON b.patron_record_id = f.patron_record_id
  AND b.item_record_id = f.item_record_metadata_id
LEFT JOIN patron_totals pt
  ON p.id = pt.patron_record_id