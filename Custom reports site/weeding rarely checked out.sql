/*
Jeremy Goldstein
Minuteman Library Network

Calculates and estimated percentage of each items time since added to the collection that it has been checked out
Use to identify weeding candidates
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
)

SELECT 
  *,
  '' AS "WEEDING: RARELY CHECKED OUT",
  '' AS "https://sic.minlib.net/reports/97"

FROM(
  SELECT
  DISTINCT rm.record_type_code||rm.record_num||'a' AS item_number,
  i.location_code||' '||loc.name AS location,
  TRIM(REPLACE(ip.call_number,'|a','')) AS call_number,
  COALESCE(vol.field_content,'') AS volume,
  b.best_author AS author,
  b.best_title AS title,
  ip.barcode,
  i.icode1 AS scat,
  CASE
  	  WHEN co.id IS NOT NULL THEN 'CHECKED OUT'
	  ELSE st.name
  END AS item_status,
  i.last_checkout_gmt::DATE AS last_checkout,
  i.checkout_total + i.renewal_total AS circulation_total,
  rm.creation_date_gmt::DATE AS created_date,
  ROUND((CAST(((i.checkout_total + i.renewal_total) * loan.est_loan_period) AS NUMERIC (12,2))/(CURRENT_DATE - rm.creation_date_gmt::DATE)) * 100,2)||'%' AS est_time_checked_out_pct

  FROM sierra_view.item_record i
  JOIN sierra_view.record_metadata rm
    ON i.id = rm.id
  JOIN sierra_view.item_record_property ip
    ON i.id = ip.item_record_id
  JOIN sierra_view.itype_property_myuser it
    ON i.itype_code_num = it.code
  JOIN sierra_view.location_myuser loc
    ON i.location_code = loc.code
  JOIN sierra_view.item_status_property_myuser st
    ON i.item_status_code = st.code
  JOIN sierra_view.bib_record_item_record_link l
    ON i.id = l.item_record_id
  JOIN sierra_view.bib_record_property b
    ON l.bib_record_id = b.bib_record_id
  LEFT JOIN sierra_view.varfield vol
    ON i.id = vol.record_id AND vol.varfield_type_code = 'v'
  LEFT JOIN sierra_view.checkout co
    ON i.id = co.item_record_id
  JOIN temp_loan_rules loan
    ON i.itype_code_num = loan.itype_code_num

  WHERE i.location_code ~ '{{location}}'
    --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
    AND rm.creation_date_gmt::DATE  < {{created_date}}
    AND i.item_status_code NOT IN ({{item_status_codes}})
    AND b.material_code IN ({{mat_type}})
    AND ROUND((CAST(((i.checkout_total + i.renewal_total) * loan.est_loan_period) AS NUMERIC (12,2))/(CURRENT_DATE - rm.creation_date_gmt::DATE)) * 100,2) < {{pct_limit}}
    AND {{age_level}}
    /*
	 age_level options are
    (i.itype_code_num NOT BETWEEN '100' AND '183' AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')) --adult
    --(i.itype_code_num BETWEEN '150' AND '183' OR SUBSTRING(i.location_code,4,1) = 'j') --juv
    --(i.itype_code_num BETWEEN '100' AND '133' OR SUBSTRING(i.location_code,4,1) = 'y') --ya
    --i.location_code ~ '\w' --all
    */
)a

ORDER BY REPLACE(est_time_checked_out_pct,'%','')::FLOAT,3,4