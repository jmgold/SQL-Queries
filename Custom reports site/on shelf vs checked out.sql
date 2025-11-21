/*
Jeremy Goldstein
Minuteman Library Network
Captures number of items/titles of shelf vs checked out at this moment.
*/
SELECT
  *,
  '' AS "ON SHELF VS CHECKED OUT",
  '' AS "https://sic.minlib.net/reports/67"
FROM (
  SELECT
    {{grouping}},
    /*Options are
    it.name AS itype
    ln.name AS language
    m.name AS mat_type
    i.icode1 AS scat_code
    i.location_code AS location
    */
    COUNT(i.id) AS total_items,
    COUNT(i.id) FILTER(WHERE c.id IS NULL AND i.item_status_code NOT IN ('t','!')) AS items_on_shelf,
    COUNT(i.id) FILTER(WHERE c.id IS NULL AND i.item_status_code = 't') AS items_in_transit,
    COUNT(i.id) FILTER(WHERE c.id IS NULL AND i.item_status_code = '!') AS items_on_holdshelf,
    COUNT(i.id) FILTER(WHERE c.id IS NOT NULL) AS items_checked_out,
    ROUND(100.0 * (CAST(COUNT(i.id) FILTER(WHERE c.id IS NULL AND i.item_status_code NOT IN ('t','!')) AS NUMERIC (12,2)) / CAST(COUNT(i.id) AS NUMERIC (12,2))), 4)||'%' AS percentage_items_on_shelf,
    COUNT(DISTINCT l.bib_record_id) AS total_tiles,
    COUNT(DISTINCT l.bib_record_id) FILTER(WHERE c.id IS NULL AND i.item_status_code NOT IN ('t','!')) AS titles_on_shelf,
    COUNT(DISTINCT l.bib_record_id) FILTER(WHERE c.id IS NULL AND i.item_status_code = 't') AS titles_in_transit,
    COUNT(DISTINCT l.bib_record_id) FILTER(WHERE c.id IS NULL AND i.item_status_code = '!') AS titles_on_holdshelf,
    COUNT(DISTINCT l.bib_record_id) FILTER(WHERE c.id IS NOT NULL) AS titles_checked_out,
    ROUND(100.0 * (CAST(COUNT(DISTINCT l.bib_record_id) FILTER(WHERE c.id IS NULL AND i.item_status_code NOT IN ('t','!')) AS NUMERIC (12,2)) / CAST(COUNT(DISTINCT l.bib_record_id) AS NUMERIC (12,2))), 4)||'%' AS percentage_titles_on_shelf

  FROM sierra_view.item_record i
  JOIN sierra_view.record_metadata rm
    ON i.id = rm.id
  JOIN sierra_view.itype_property_myuser it
    ON i.itype_code_num = it.code
  JOIN sierra_view.bib_record_item_record_link l
    ON i.id = l.item_record_id
  JOIN sierra_view.bib_record b
    ON l.bib_record_id = b.id
  JOIN sierra_view.material_property_myuser m
    ON b.bcode2 = m.code
  JOIN sierra_view.language_property_myuser ln
    ON b.language_code = ln.code
  LEFT JOIN sierra_view.checkout c
    ON i.id = c.item_record_id

  WHERE i.location_code ~ {{location}}
  --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
    AND i.item_status_code NOT IN ({{Item_Status_Codes}})
    AND rm.creation_date_gmt < {{date_limit}}

  GROUP BY 1
  ORDER BY 1
)a