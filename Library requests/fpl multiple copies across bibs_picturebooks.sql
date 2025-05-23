/*
Jeremy Goldstein
Minuteman Library Network

Find picture books where the library owns multiple copies, including some cases where those copies exist on different bibs
depending on best_title/best_author matching across records
*/

WITH dupes AS (
SELECT
  b.best_title,
  b.best_author,
  COUNT(i.id),
  STRING_AGG(i.id::VARCHAR,',') AS ids
FROM sierra_view.item_record i
JOIN sierra_view.bib_record_item_record_link l
  ON i.id = l.item_record_id
JOIN sierra_view.bib_record_property b
  ON l.bib_record_id = b.bib_record_id
--libarary specific filter selections  
WHERE
  i.location_code = 'fplj' 
  AND i.itype_code_num = '150'
  AND i.icode1 = '206'

GROUP BY 1,2
HAVING COUNT(i.id) > 1
),

item_list AS (
SELECT
  UNNEST(STRING_TO_ARRAY(d.ids,',')) AS item_id

FROM dupes d
)

SELECT
  REGEXP_REPLACE(ip.call_number,'^\|a','') AS call_number,
  b.best_title,
  b.best_author,
  rm.record_type_code||rm.record_num||'a' AS bib_number,
  ip.barcode,
  i.checkout_total,
  i.year_to_date_checkout_total,
  i.last_checkout_gmt::DATE AS last_checkout_date

FROM item_list il
JOIN sierra_view.item_record_property ip
  ON il.item_id = ip.item_record_id::VARCHAR
JOIN sierra_view.bib_record_item_record_link l
  ON ip.item_record_id = l.item_record_id
JOIN sierra_view.bib_record_property b
  ON l.bib_record_id = b.bib_record_id
JOIN sierra_view.record_metadata rm
  ON b.bib_record_id = rm.id
JOIN sierra_view.item_record i
  ON ip.item_record_id = i.id
  
ORDER BY 3,2,1
