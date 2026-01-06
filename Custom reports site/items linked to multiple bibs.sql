/*
Jeremy Goldstein
Minuteman Library Network

Identifies items records that have been linked to multiple bib records
*/

SELECT *,
  '' AS "ITEMS LINKED TO MULTIPLE BIBS",
  '' AS "https://sic.minlib.net/reports/40"

FROM (
  SELECT
    ir.record_type_code||ir.record_num||'a' AS item_number,
    i.location_code,
    r.record_type_code||r.record_num||'a' AS bib_number,
    b.best_title AS title

  FROM sierra_view.record_metadata as r
  JOIN sierra_view.bib_record_item_record_link as l
    ON l.bib_record_id = r.id
  JOIN sierra_view.record_metadata as ir
    ON ir.id = l.item_record_id
  JOIN sierra_view.item_record i
    ON l.item_record_id = i.id
  JOIN sierra_view.bib_record_property b
    ON l.bib_record_id = b.bib_record_id

  WHERE l.item_record_id IN (
	SELECT
	  l.item_record_id

	FROM 	sierra_view.bib_record_item_record_link as l

	GROUP BY l.item_record_id
	HAVING COUNT(item_record_id) > 1
  )
    AND i.location_code ~ {{location}}
    --location will take the form ^oln, which in this example looks for all locations starting with the string oln.

  ORDER BY 1,4
)a