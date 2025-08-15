/*
Jeremy Goldstein
Minuteman Library Network

Data for heatmap of which locations patrons in a given municipality checkout materials from
*/

SELECT
  SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,11) AS census_tract,
  '2025-07-01' AS "month",
  sg.location_code AS checkout_location,
  COUNT(t.id) AS checkout_count,
  COUNT(DISTINCT t.patron_record_id) AS patron_count,
  'https://censusreporter.org/profiles/14000US'||SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,11) AS census_reporter_url

FROM sierra_view.patron_record p
JOIN sierra_view.circ_trans t
  ON p.id = t.patron_record_id
JOIN sierra_view.statistic_group_myuser sg
  ON t.stat_group_code_num = sg.code
--for census field
LEFT JOIN sierra_view.varfield v
  ON p.id = v.record_id
  AND v.varfield_type_code = 'k'
  AND v.field_content ~ '^\|s\d{2}'

WHERE p.pcode3 = '113'
  AND t.op_code = 'o'
  AND t.transaction_gmt::DATE > CURRENT_DATE - INTERVAL '1 MONTH'
GROUP BY 1,2,3
ORDER BY 3 DESC