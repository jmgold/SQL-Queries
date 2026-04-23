/*
request to compare item totals and last year circ across three locations for books based on Disney's Frozen
*/

WITH frozen_list AS (
  SELECT
    b.id
  FROM sierra_view.bib_record b
  JOIN sierra_view.phrase_entry t
    ON b.id = t.record_id AND t.varfield_type_code = 'u'
  
  WHERE t.index_entry ~ '^frozen( ii)? motion picture.*'
    AND b.bcode2 IN ('a','9','p')
)

SELECT
  id2reckey(b.bib_record_id)||'a' AS bib_record,
  b.best_title AS title,
  b.best_author AS author,
  COUNT(i.id) FILTER(WHERE i.location_code ~ '^arl') AS arl_copies,
  COUNT(i.id) FILTER(WHERE i.location_code ~ '^ar2') AS ar2_copies,
  COUNT(i.id) FILTER(WHERE i.location_code ~ '^lex') AS lex_copies,
  COALESCE(SUM(i.last_year_to_date_checkout_total) FILTER(WHERE i.location_code ~ '^arl'),0) AS arl_fy25_checkouts,
  COALESCE(SUM(i.last_year_to_date_checkout_total) FILTER(WHERE i.location_code ~ '^ar2'),0) AS ar2_fy25_checkouts,
  COALESCE(SUM(i.last_year_to_date_checkout_total) FILTER(WHERE i.location_code ~ '^lex'),0) AS lex_fy25_checkouts
  
FROM frozen_list f
JOIN sierra_view.bib_record_property b
  ON f.id = b.bib_record_id
JOIN sierra_view.bib_record_item_record_link l
  ON b.bib_record_id = l.bib_record_id
JOIN sierra_view.item_record i
  ON l.item_record_id = i.id

WHERE SUBSTRING(i.location_code,1,3) IN ('arl','ar2','lex')

GROUP BY 1,2,3
