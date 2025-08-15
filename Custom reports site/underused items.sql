/*
Jeremy Goldstein
Minuteman Library Network

Identifies underused items by compairing the est time spent checked out to that of all copies attached to a given record
*/

/*
Estimates the avg loan period for each itype across the network based on current due dates and checkout dates
Filters out checkouts involving renewals to avoid skewing the estimates
*/
WITH temp_loan_rules AS (
  SELECT 
    i.itype_code_num,
    MODE() WITHIN GROUP (ORDER BY o.due_gmt::DATE - o.checkout_gmt::DATE) AS est_loan_period

  FROM sierra_view.checkout o
  JOIN sierra_view.item_record i
    ON o.item_record_id = i.id

  WHERE o.renewal_count = 0
  GROUP BY 1
),

title_usage AS (
  SELECT
    b.best_title AS title,
    b.best_author AS author,
    b.bib_record_id,
    ROUND(AVG(ROUND((CAST(((i.checkout_total + i.renewal_total) * loan.est_loan_period) AS NUMERIC (12,2))/(CURRENT_DATE - rm.creation_date_gmt::DATE)) * 100,2)),2) AS avg_time_checked_out_pct

  FROM sierra_view.item_record i
  JOIN sierra_view.bib_record_item_record_link l
    ON i.id = l.item_record_id
  JOIN sierra_view.record_metadata rm
    ON i.id = rm.id
  JOIN sierra_view.bib_record_property b
    ON l.bib_record_id = b.bib_record_id
  JOIN temp_loan_rules loan
    ON i.itype_code_num = loan.itype_code_num

  WHERE rm.creation_date_gmt::DATE < {{created_date}}
    AND i.item_status_code NOT IN ({{item_status_codes}})
    AND b.material_code IN ({{mat_type}})
    GROUP BY 1,2,3
)

SELECT
  *,
  '' AS "UNDERUSED ITEMS",
  '' AS "https://sic.minlib.net/reports/32"
FROM (
  SELECT
  rm.record_type_code||rm.record_num||'a' AS item_number,
  a.title,
  a.author,
  TRIM(REPLACE(ip.call_number,'|a','')) AS call_number,
  i.checkout_total + i.renewal_total AS circulation_total,
  rm.creation_date_gmt::DATE AS creation_date,
  --avg age in days for time_checked_out_pct calculation
  i.last_checkout_gmt::DATE AS last_checkout_date,
  a.avg_time_checked_out_pct||'%' AS avg_time_checked_out_pct,
  ROUND((CAST(((i.checkout_total + i.renewal_total) * loan.est_loan_period) AS NUMERIC (12,2))/(CURRENT_DATE - rm.creation_date_gmt::DATE)) * 100,2)||'%' AS time_checked_out_pct,
  a.avg_time_checked_out_pct - (ROUND((CAST(((i.checkout_total + i.renewal_total) * loan.est_loan_period) AS NUMERIC (12,2))/(CURRENT_DATE - rm.creation_date_gmt::DATE)) * 100,2)) AS time_checked_out_pct_difference

  FROM sierra_view.item_record i
  JOIN sierra_view.record_metadata rm
    ON i.id = rm.id
  JOIN sierra_view.item_record_property ip
    ON i.id = ip.item_record_id
  JOIN sierra_view.bib_record_item_record_link l
    ON i.id = l.item_record_id
  JOIN temp_loan_rules loan
    ON i.itype_code_num = loan.itype_code_num
  JOIN title_usage AS a
    ON l.bib_record_id = a.bib_record_id

  WHERE i.location_code ~ '{{location}}'
    AND rm.creation_date_gmt::DATE < {{created_date}}
    AND i.item_status_code NOT IN ({{item_status_codes}})
    AND ROUND((CAST(((i.checkout_total + i.renewal_total) * loan.est_loan_period) AS NUMERIC (12,2))/(CURRENT_DATE - rm.creation_date_gmt::DATE)) * 100,2) < a.avg_time_checked_out_pct
    AND {{age_level}}
    --SUBSTRING(i.location_code,4,1) NOT IN ('y','j') --adult
    --SUBSTRING(i.location_code,4,1) = 'j' --juv
    --SUBSTRING(i.location_code,4,1) = 'y' --ya
    --i.location_code ~ '\w' --all
)inner_query	
ORDER BY 10 DESC, 4