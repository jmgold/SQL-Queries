/*
Jeremy Goldstein
Minuteman Library Network

Data for heatmap of which locations patrons in a given municipality checkout materials from
*/

SELECT
  SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,11) AS census_tract,
  /*'2025-07-01'*/ TO_CHAR(CURRENT_DATE - INTERVAL '1 MONTH', 'YYYY MON') AS "month",
  SUBSTRING(sg.location_code,1,3) AS checkout_location,
  SUBSTRING(p.home_library_code,1,3) AS home_library,
  pt."name" AS ptype,
  it.name AS item_type,
  COUNT(t.id) AS checkout_count,
  COUNT(DISTINCT t.patron_record_id) AS patron_count
  
FROM sierra_view.patron_record p
JOIN sierra_view.circ_trans t
  ON p.id = t.patron_record_id
JOIN sierra_view.statistic_group_myuser sg
  ON t.stat_group_code_num = sg.code
JOIN sierra_view.itype_property_myuser it
  ON t.itype_code_num = it.code
JOIN sierra_view.ptype_property_myuser pt
  ON p.ptype_code = pt.value
--for census field
LEFT JOIN sierra_view.varfield v
  ON p.id = v.record_id
  AND v.varfield_type_code = 'k'
  AND v.field_content ~ '^\|s\d{2}'

WHERE t.op_code = 'o'
  AND t.transaction_gmt::DATE > CURRENT_DATE - INTERVAL '1 MONTH'
GROUP BY 1,2,3,4,5,6
ORDER BY 3,4 