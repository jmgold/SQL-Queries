WITH item_counts AS (
  SELECT
    CASE
      WHEN SUBSTRING(i.location_code,4,1) = 'y' THEN 'YA'
      WHEN SUBSTRING(i.location_code,4,1) = 'j' THEN 'Children''s'
      ELSE 'Adult'
    END AS age_level,
    COUNT(i.id) AS item_total,
    ROUND(100.0 * (CAST(COUNT(i.id) AS NUMERIC(12,2)) / (SELECT CAST(COUNT(ir.id) AS NUMERIC(12,2)) FROM sierra_view.item_record ir))) AS collection_pct
    
  FROM sierra_view.item_record i
  GROUP BY 1
)

SELECT 
  CASE
    WHEN SUBSTRING(i.location_code,4,1) = 'y' THEN 'YA'
    WHEN SUBSTRING(i.location_code,4,1) = 'j' THEN 'Children''s'
    ELSE 'Adult'
  END AS age_level,
  ic.item_total,
  COUNT(DISTINCT i.id) AS total_billed_items,
  ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) AS NUMERIC (12,4)) / CAST(ic.item_total AS NUMERIC (12,4)))) AS pct_billed,
  ic.collection_pct,
  COUNT(DISTINCT i.id) FILTER(WHERE CURRENT_DATE - o.due_gmt BETWEEN '1 day' AND '89 days') AS "< 90 days",
  COUNT(DISTINCT i.id) FILTER(WHERE CURRENT_DATE - o.due_gmt BETWEEN '90 days' AND '179 days') AS "< 180 days",
  COUNT(DISTINCT i.id) FILTER(WHERE CURRENT_DATE - o.due_gmt BETWEEN '180 days' AND '364 days') AS "< 1 year",
  COUNT(DISTINCT i.id) FILTER(WHERE CURRENT_DATE - o.due_gmt BETWEEN '1 year' AND '729 days') AS "1-2 years",
  COUNT(DISTINCT i.id) FILTER(WHERE CURRENT_DATE - o.due_gmt BETWEEN '2 years' AND '1094 days') AS "2-3 years",
  COUNT(DISTINCT i.id) FILTER(WHERE CURRENT_DATE - o.due_gmt BETWEEN '3 years' AND '1459 days') AS "3-4 years",
  COUNT(DISTINCT i.id) FILTER(WHERE CURRENT_DATE - o.due_gmt BETWEEN '4 years' AND '1824 days') AS "4-5 years",
  COUNT(DISTINCT i.id) FILTER(WHERE CURRENT_DATE - o.due_gmt BETWEEN '5 years' AND '2189 days') AS "5-6 years",
  COUNT(DISTINCT i.id) FILTER(WHERE CURRENT_DATE - o.due_gmt >= '6 years') AS "6+ years"
FROM sierra_view.item_record i
JOIN item_counts ic
  ON CASE
       WHEN SUBSTRING(i.location_code,4,1) = 'y' THEN 'YA'
       WHEN SUBSTRING(i.location_code,4,1) = 'j' THEN 'Children''s'
       ELSE 'Adult'
     END = ic.age_level
JOIN sierra_view.checkout o
  ON i.id = o.item_record_id
WHERE i.item_status_code = 'n'

GROUP BY 1,5,ic.item_total