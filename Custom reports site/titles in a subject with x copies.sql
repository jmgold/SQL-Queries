/*
Jeremy Goldstein
Minuteman Library Network

Identifies titles in a specified subject where there are at least x copies
Designed for finding titles suitable for book groups
*/

SELECT
  *,
  '' AS "TITLES IN A SUBJECT WITH X COPIES",
  '' AS "https://sic.minlib.net/reports/52"
FROM (
  SELECT
    rm.record_type_code||rm.record_num||'a' AS bib_number,
    b.best_title AS title,
    b.best_author AS author,
    b.publish_year,
    COUNT(DISTINCT bi.id) AS copies
  
  FROM sierra_view.bib_record_property b
  JOIN sierra_view.bib_record_item_record_link bi
    ON b.bib_record_id = bi.bib_record_id
  JOIN sierra_view.item_record i
    ON bi.item_record_id = i.id
  JOIN sierra_view.phrase_entry p
    ON b.bib_record_id = p.record_id
	 AND p.index_tag = 'd'
  JOIN sierra_view.record_metadata rm
    ON b.bib_record_id = rm.id

  WHERE b.material_code IN ({{mat_type}})
	 AND i.item_status_code NOT IN ({{item_status_codes}})
    {{#if limit_available}}AND i.is_available_at_library = 'true'{{/if limit_available}}
	 AND REPLACE(p.index_entry, ' ', '') LIKE TRANSLATE(REGEXP_REPLACE(LOWER('%{{subject}}%'),'\|[a-z]','','g'), ' .,-()', '')
  GROUP BY 1,2,3,4
  HAVING COUNT(DISTINCT bi.id) >= {{copies}}
)a