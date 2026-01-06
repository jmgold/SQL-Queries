/*
Jeremy Goldstein
Minuteman Library Network

use to gather Items where a library owns multiple circulating copies of a title.
Passed variables for owning location, item statuses to exclude, mat types, copies greater than x and records created before
*/

WITH bib_list AS (
  SELECT 
    l.bib_record_id,
    COUNT(i.id)
  FROM sierra_view.bib_record b
  JOIN sierra_view.bib_record_item_record_link l
    ON b.id = l.bib_record_id
  JOIN sierra_view.item_record i
    ON i.id = l.item_record_id
  JOIN sierra_view.record_metadata m
    ON i.id = m.id

  WHERE b.bcode1 = 'm' 
    AND b.bcode2 IN ({{mat_type}}) 
    AND i.location_code ~ '{{location}}'
    --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
    AND i.item_status_code NOT IN ({{item_status_codes}})
	 AND m.creation_date_gmt < {{created_date}}
  
  GROUP BY 1
  HAVING COUNT(i.id) > {{copies}}
)

SELECT 
  *,
  '' AS "MULTIPLE ITEMS",
  '' AS "https://sic.minlib.net/reports/69"

FROM (
  SELECT
    ID2RECKEY(b.bib_record_id)||'a' AS bib_number,
    b.best_title AS title,
    b.best_author AS author,
    id2reckey(ip.item_record_id)||'a' AS item_number,
    ip.barcode,
    i.location_code,
    REPLACE(ip.call_number,'|a','') AS call_number,
    i.checkout_total,
    i.last_checkout_gmt::DATE AS last_checkout,
    rm.creation_date_gmt::DATE AS creation_date,
    CASE
	    WHEN C.id IS NOT NULL THEN 'CHECKED OUT'
	    ELSE status.name
    END AS status,
    COALESCE(TO_CHAR(C.due_gmt, 'YYYY-mm-dd'),'') AS due_date

  FROM bib_list bl
  JOIN sierra_view.bib_record_property b
    ON bl.bib_record_id = b.bib_record_id
  JOIN sierra_view.bib_record_item_record_link l
    ON b.bib_record_id = l.bib_record_id
  JOIN sierra_view.item_record_property ip
    ON l.item_record_id = ip.item_record_id
  JOIN sierra_view.item_record i
    ON ip.item_record_id = i.id
  LEFT JOIN sierra_view.checkout c
    ON i.id = c.item_record_id
  JOIN sierra_view.item_status_property_myuser status
    ON i.item_status_code = status.code
  JOIN sierra_view.record_metadata rm
    ON i.id = rm.id
  --use to weed out items with volume fields, which in some cases may throw off results
  {{#if Exclude}}
  LEFT JOIN sierra_view.subfield v
    ON i.id = v.record_id
	 AND v.field_type_code = 'v'

  WHERE i.location_code ~ '{{location}}'
    --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
    AND i.item_status_code NOT IN ({{item_status_codes}})
	 AND rm.creation_date_gmt < {{created_date}}
  GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12
  HAVING COUNT(v.*) = 0 
  {{/if Exclude}}

  ORDER BY 1,6,7
)a