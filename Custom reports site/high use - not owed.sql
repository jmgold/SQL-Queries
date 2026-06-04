/*
Jeremy Goldstein
Minuteman Library Network

Identifies the most heavily uesed titles based on the estimated percentage of time spent checked out
that are not owned at a location
*/

WITH temp_loan_rules AS (
   SELECT
     i.itype_code_num,
     ROUND(AVG(EXTRACT(DAY FROM l.est_loan_period))) AS est_loan_period
   FROM sierra_view.item_record i
   JOIN sierra_view.checkout c
     ON i.id = c.item_record_id
   JOIN (
     SELECT
       o.loanrule_code_num AS loanrule_num,
       MIN(AGE(o.due_gmt::date, o.checkout_gmt::date)) AS est_loan_period
     FROM sierra_view.checkout o
     
	  WHERE o.loanrule_code_num NOT IN ('1','288','493','494','495','496','497','498','999')
     GROUP BY o.loanrule_code_num
     HAVING COUNT(o.loanrule_code_num) > 5
    ) l
	   ON c.loanrule_code_num = l.loanrule_num
   GROUP BY i.itype_code_num
)

SELECT 
  *,
  '' AS "HIGH USE: NOT OWNED",
  '' AS "https://sic.minlib.net/reports/33"

FROM (
  SELECT
    b.best_title AS title,
    b.best_author AS author,
    'b'||mb.record_num||'a' AS bib_number,
    ROUND(AVG(i.checkout_total + i.renewal_total),2) AS avg_circulation_total,
    MIN(m.creation_date_gmt::DATE) AS oldest_created_date,
    ROUND(AVG(
	   CASE
		  WHEN ((CAST(((i.checkout_total + i.renewal_total) * loan.est_loan_period) AS NUMERIC (12,2))/(CURRENT_DATE - m.creation_date_gmt::DATE)) * 100) > 100 THEN 100
	     ELSE ((CAST(((i.checkout_total + i.renewal_total) * loan.est_loan_period) AS NUMERIC (12,2))/(CURRENT_DATE - m.creation_date_gmt::DATE)) * 100)
	   END
    ),2) AS avg_time_checked_out_pct,
    COUNT(l.id) AS item_total,
    MAX(i.last_checkout_gmt::DATE) AS last_checkout_date

  FROM sierra_view.bib_record_property b
  JOIN sierra_view.bib_record br
    ON b.bib_record_id = br.id
  JOIN sierra_view.bib_record_item_record_link l
    ON b.bib_record_id = l.bib_record_id 
  JOIN sierra_view.item_record i
    ON l.item_record_id = i.id
  JOIN temp_loan_rules loan
    ON i.itype_code_num = loan.itype_code_num
  JOIN sierra_view.record_metadata m
    ON i.id = m.id
  JOIN sierra_view.record_metadata mb
    ON b.bib_record_id = mb.id

  WHERE b.material_code IN ({{mat_type}})
	 AND br.bcode3 != 'e'
    AND i.item_status_code NOT IN ({{item_status_codes}})
	 AND m.creation_date_gmt::DATE < {{created_date}}
  GROUP BY 1,2,3
  HAVING COUNT(i.id) FILTER (WHERE i.location_code ~ '{{location}}') = 0
  --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
  ORDER BY 6 DESC,1
  LIMIT {{qty}}
)a