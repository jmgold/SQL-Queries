/*
Jeremy Goldstein
Minuteman Library Network
Gathers the top titles in the network ,that are not owned locally, in a dei topical area, grouped by a choice of performance metrics
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
	JOIN 	sierra_view.phrase_entry d
	  ON br.id = d.record_id
	  AND d.index_tag = 'd'
	  AND d.is_permuted = false
	
	WHERE i.item_status_code NOT IN ({{item_status_codes}})
	  AND rm.creation_date_gmt < {{created_date}}::DATE
	  AND br.bcode3 NOT IN ('g','o','r','z','l','q','n')
	  --exclude guidebooks
	  AND REPLACE(d.index_entry,'.','') !~ '^\y(?!\w((ecology)|(ecotourism)|(ecosystems)|(environmentalism)|(african american)|(african diaspora)|(blues music)|(freedom trail)|(underground railroad)|(women)|(ethnic restaurants)|
	  (social life and customs)|(older people)|(people with disabilities)|(gay(s|\y(?!(head|john))))|(lesbian)|(bisexual)|(gender)|(sexual minorities)|(indian (art|trails))|(indians of)|(inca(s|n))|
	  (christian (art|antiquities|saints|shrine|travel))|(pilgrims and pilgrimages)|(jews)|(judaism)|((jewish|islamic) architecture)|(convents)|(sacred space)|(sepulchral monuments)|(spanish mission)|(spiritual retreat)|(temples)|(houses of prayer)|(religious institutions)|(monasteries)|(holocaust)|(church (architecture|buildings|decoration))))\w.*((guidebooks)|(description and travel))'
	  AND REPLACE(d.index_entry,'.','') ~ {{topic}}
	  
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
  '' AS "DEI UNOWNED",
  '' AS "https://sic.minlib.net/reports/102"
FROM (
  SELECT
  'b'||mb.record_num||'a' AS bib_number,
  b.best_title AS title,
  b.best_author AS author,
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
  LEFT JOIN hold_count AS h
    ON b.bib_record_id = h.bib_record_id
  LEFT JOIN isbn_data isbn
    ON b.bib_record_id = isbn.record_id

  WHERE b.material_code IN ({{mat_type}})

  GROUP BY 1,2,3,4,6,h.count_holds_on_title
  ORDER BY 5 DESC
  LIMIT {{qty}}
)a