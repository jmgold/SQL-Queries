/*
Jeremy Goldstein
Minuteman Library Network
Query identifies titles that have spent a large portion of their time in the collection checked out,
best when new titles are excluded.
*/

WITH loan_periods AS (
   SELECT
     i.itype_code_num,
     ROUND(AVG(EXTRACT(DAY FROM l.est_loan_period))) AS est_loan_period
   FROM sierra_view.checkout c
   JOIN (
     SELECT
       f.loanrule_code_num AS loanrule_num,
       MIN(AGE(f.due_gmt::date, f.checkout_gmt::date)) AS est_loan_period
     FROM sierra_view.fine f
     
	  WHERE f.loanrule_code_num NOT IN ('1','288','493','494','495','496','497','498','999')
     GROUP BY f.loanrule_code_num
     HAVING COUNT(f.loanrule_code_num) > 5
    ) l
	   ON c.loanrule_code_num = l.loanrule_num
   JOIN sierra_view.item_record i
	  ON c.item_record_id = i.id
   GROUP BY i.itype_code_num
)

SELECT
  *,
  '' AS "HIGH USE: OWNED",
  '' AS "https://sic.minlib.net/reports/34"
FROM (
  SELECT
    b.best_title AS title,
    b.best_author AS author,
    mb.record_type_code||mb.record_num||'a' AS bib_number,
    SUM(i.checkout_total + i.renewal_total) AS circulation_total,
    MIN(m.creation_date_gmt::DATE) AS oldest_created_date,
    ROUND(AVG(CASE
	   WHEN ((CAST(((i.checkout_total + i.renewal_total) * COALESCE(loan.est_loan_period,14)) AS NUMERIC (12,2))/(CURRENT_DATE - m.creation_date_gmt::DATE)) * 100) > 100 THEN 100
	   ELSE ((CAST(((i.checkout_total + i.renewal_total) * COALESCE(loan.est_loan_period,14)) AS NUMERIC (12,2))/(CURRENT_DATE - m.creation_date_gmt::DATE)) * 100)
	 END),2) AS avg_time_checked_out_pct,
    COUNT(l.id) AS item_total,
    MAX(i.last_checkout_gmt::DATE) AS last_checkout_date

  FROM sierra_view.bib_record_property b
  JOIN sierra_view.bib_record_item_record_link l
    ON b.bib_record_id = l.bib_record_id 
  JOIN sierra_view.item_record i
    ON l.item_record_id = i.id
  JOIN sierra_view.record_metadata m
    ON i.id = m.id 
  JOIN sierra_view.record_metadata mb
    ON b.bib_record_id = mb.id
  JOIN sierra_view.bib_record br
    ON b.bib_record_id = br.id
  LEFT JOIN loan_periods loan
    ON i.itype_code_num = loan.itype_code_num

  WHERE b.material_code IN ({{mat_type}})
    AND m.creation_date_gmt::DATE < {{created_date}}
    AND i.item_status_code NOT IN ({{item_status_codes}})
    AND i.location_code ~ {{location}}
    --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
    AND {{age_level}}
    /*
    SUBSTRING(i.location_code,4,1) NOT IN ('y','j') --adult
    SUBSTRING(i.location_code,4,1) = 'j' --juv
    SUBSTRING(i.location_code,4,1) = 'y' --ya
    i.location_code ~ '\w' --all
    */
    AND br.bcode3 != 'e'

  GROUP BY 1,2,3
  ORDER BY 6 DESC,1
  LIMIT {{qty}}
)a