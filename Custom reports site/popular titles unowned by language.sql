/*
Jeremy Goldstein
Minuteman Library Network
Gathers the top titles in the network ,that are not owned locally, limited to one or more languages, grouped by a choice of performance metrics
*/

WITH hold_count AS ( 
  SELECT
	 l.bib_record_id,
	 COUNT(DISTINCT h.id) AS count_holds_on_title

	 --reconciles bib,item and volume level holds
	FROM sierra_view.hold h
	JOIN sierra_view.bib_record_item_record_link l
	  ON h.record_id = l.item_record_id
	  OR h.record_id = l.bib_record_id

	GROUP BY 1
	HAVING COUNT(DISTINCT h.id) > 1
),
-- Pre-compute loan periods to avoid repeated subquery execution
loan_periods AS (
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
),
-- Pre-filter and pre-compute ISBN/UPC to avoid correlated subquery
isbn_data AS (
  SELECT
    DISTINCT s.record_id,
    FIRST_VALUE(SUBSTRING(s.content FROM '[0-9X]+')) 
      OVER (PARTITION BY s.record_id ORDER BY s.occ_num) AS isbn_upc
  FROM sierra_view.subfield s
  
  WHERE s.marc_tag IN ('020','024') 
    AND s.tag = 'a'
    AND s.content ~ '[0-9X]+'
),
--find bib records that are not owned by a location,

unowned AS (
	SELECT
	  l.bib_record_id
	FROM sierra_view.bib_record_item_record_link l
	JOIN sierra_view.item_record i
	  ON l.item_record_id = i.id
	JOIN sierra_view.record_metadata rm
	  ON i.id = rm.id
	JOIN 	sierra_view.bib_record br
	  ON l.bib_record_id = br.id
	
	WHERE i.item_status_code NOT IN ({{item_status_codes}})
	  AND br.language_code IN ({{language}})
	  AND rm.creation_date_gmt < {{created_date}}::DATE
	  AND br.bcode3 NOT IN ('g','o','r','z','l','q','n')
	  
	GROUP BY 1
	HAVING COUNT(i.id) FILTER(WHERE i.location_code ~ '{{location}}') = 0
	  AND COUNT(i.id) FILTER(WHERE {{age_level}}) > 0
	/*
	SUBSTRING(i.location_code,4,1) NOT IN ('y','j','s') --adult
	SUBSTRING(i.location_code,4,1) = 'j' --juv
	SUBSTRING(i.location_code,4,1) = 'y' --ya
	i.location_code ~ '\w' --all
	*/
)

SELECT
  *,
  '' AS "POPULAR TITLES UNOWNED BY LANGUAGE",
  '' AS "https://sic.minlib.net/reports/88"
  FROM (
    SELECT
    'b'||mb.record_num||'a' AS bib_number,
    b.best_title AS title,
    CASE
    	WHEN vt.field_content IS NULL THEN b.best_title
      ELSE REGEXP_REPLACE(SPLIT_PART(REGEXP_REPLACE(vt.field_content,'^.*\|a',''),'|',1),'\s?(\.|\,|\:|\/|\;|\=)\s?$','')
    END AS title_nonroman,
    b.best_author AS author,
    CASE
   	WHEN va.field_content IS NULL THEN b.best_author
      ELSE REGEXP_REPLACE(REPLACE(REPLACE(REGEXP_REPLACE(va.field_content,'^.*\|a',''),'|d',' '),'|q',' '),'\s?(\.|\,|\:|\/|\;|\=)\s?$','')
    END AS author_nonroman,
    b.publish_year,
    {{grouping}},
    /*
    Grouping options
    ROUND(AVG((CAST(((i.checkout_total + i.renewal_total) * loan.est_loan_period) AS NUMERIC (12,2))/(NULLIF((CURRENT_DATE - m.creation_date_gmt::DATE),0)) * 100),2) AS time_checked_out_pct
    ROUND(CAST(SUM(i.checkout_total) + SUM(i.renewal_total) AS NUMERIC (12,2))/CAST(COUNT (i.id) AS NUMERIC (12,2)), 2) AS turnover
    SUM(i.year_to_date_checkout_total + i.last_year_to_date_checkout_total) AS total_checkouts
    SUM(i.checkout_total + i.renewal_total) AS total_circulation
    SUM(i.checkout_total) AS total_checkouts
    SUM(i.year_to_date_checkout_total) AS total_year_to_date_checkouts
    SUM(i.last_year_to_date_checkout_total) AS total_last_year_to_date_checkouts
    COALESCE(h.count_holds_on_title,0) AS total_holds
    */
    isbn.isbn_upc AS "isbn/upc"

  FROM unowned o
  JOIN  sierra_view.bib_record_property b
    ON o.bib_record_id = b.bib_record_id
  JOIN sierra_view.record_metadata mb
    ON b.bib_record_id = mb.id
  JOIN sierra_view.bib_record_item_record_link l
    ON b.bib_record_id = l.bib_record_id
  JOIN sierra_view.item_record i
    ON l.item_record_id = i.id
  JOIN sierra_view.record_metadata m
    ON i.id = m.id
  JOIN loan_periods loan
    ON i.itype_code_num = loan.itype_code_num
  LEFT JOIN sierra_view.varfield vt
    ON b.bib_record_id = vt.record_id
	   AND vt.marc_tag = '880'
	   AND vt.field_content ~ '^/|6245'
  LEFT JOIN sierra_view.varfield va
    ON b.bib_record_id = va.record_id
      AND va.marc_tag = '880'
      AND va.field_content ~ '^/|6100'
  LEFT JOIN hold_count AS h
    ON b.bib_record_id = h.bib_record_id
  LEFT JOIN isbn_data isbn
    ON b.bib_record_id = isbn.record_id


WHERE b.material_code IN ({{mat_type}})

GROUP BY
1,2,3,4,5,6,8,h.count_holds_on_title
ORDER BY 7 DESC
LIMIT {{qty}}
)a