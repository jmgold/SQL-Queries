/*
Jeremy Goldstein
Minuteman Library Network

use to gather bibs where a library owns multiple circulating copies of a title.
and recent circ suggests that some copies could be weeded
Passed variables for owning location, item statuses to exclude, copies greater than x and turnover less than y
*/

SELECT *,
  '' AS "WEEDING: MULTIPLE COPIES",
  '' AS "https://sic.minlib.net/reports/21"

FROM (
  SELECT 
    id2reckey(b.bib_record_id)||'a' AS bib_number,
    b.best_title AS title,
    COUNT(i.id) AS item_count,
    SUM(i.last_year_to_date_checkout_total) AS last_ytd_checkouts,
    SUM(i.year_to_date_checkout_total) AS ytd_checkouts,
    ROUND((SUM(i.year_to_date_checkout_total) + SUM(i.last_year_to_date_checkout_total))::NUMERIC/count(i.id),2) AS turnover,
    STRING_AGG(id2reckey(i.id)||'a',',') AS item_numbers,
    STRING_AGG(DISTINCT TRIM(REPLACE(ip.call_number,'|a','')),',') AS call_numbers,
    STRING_AGG(DISTINCT i.icode1::VARCHAR,', ') AS scat_codes,
    STRING_AGG(DISTINCT i.itype_code_num::VARCHAR,', ') AS itypes

  FROM sierra_view.bib_record_property b
  JOIN sierra_view.bib_record_item_record_link l
    ON b.bib_record_id = l.bib_record_id
  JOIN sierra_view.item_record i
    ON i.id = l.item_record_id
  JOIN sierra_view.record_metadata m
    ON i.id = m.id
  JOIN sierra_view.item_record_property ip
    ON i.id = ip.item_record_id
  JOIN sierra_view.bib_record bib
    ON b.bib_record_id = bib.id
    AND bib.bcode1 = 'm'
  {{#if Exclude}}
  LEFT JOIN sierra_view.subfield v
    ON i.id = v.record_id
	 AND v.field_type_code = 'v'
  {{/if Exclude}}

  WHERE b.material_code IN ({{mat_type}})
	 AND m.creation_date_gmt < {{created_date}}
    AND i.item_status_code NOT IN ({{Item_Status_Codes}}) 
    AND i.location_code ~ '{{Location}}'
    --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
  GROUP BY 1, 2
  HAVING COUNT(i.id) > {{Item_Count}}
    AND (SUM(i.year_to_date_checkout_total) + SUM(i.last_year_to_date_checkout_total))::NUMERIC/count(i.id) < {{Turnover}}
    {{#if Exclude}}
    --use to weed out items with volume fields, which in some cases may throw off results
    AND COUNT(v.*) = 0 
    {{/if Exclude}}
  ORDER BY 6,3 DESC
)a