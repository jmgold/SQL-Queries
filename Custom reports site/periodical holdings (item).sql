/*
Jeremy Goldstein
Minuteman Library Network
Counts number of items attached to periodical records for a given location
*/

SELECT 
  *,
  '' AS "PERIODICAL HOLDINGS (ITEM)",
  '' AS "https://sic.minlib.net/reports/106"
FROM (
  SELECT
    rm.record_type_code||rm.record_num||'a' AS bib_num,
    bp.best_title AS title,
    STRING_AGG(DISTINCT(i.location_code), ',') AS item_locations,
    COALESCE(vi.field_content,'') AS item_rec_holdings,
    COUNT(DISTINCT i.id) AS item_count

  FROM sierra_view.item_record i
  JOIN sierra_view.bib_record_item_record_link bi
    ON i.id = bi.item_record_id
  JOIN sierra_view.bib_record_property bp
    ON bi.bib_record_id = bp.bib_record_id
  JOIN sierra_view.record_metadata rm
    ON bp.bib_record_id = rm.id
  LEFT JOIN sierra_view.varfield vi
    ON i.id = vi.record_id
	 AND vi.varfield_type_code = 'v'
	 AND i.item_status_code = 'j'

  WHERE bp.material_code = '3'
	 AND i.location_code ~ '{{location}}'
	 AND i.item_status_code NOT IN ('m', 'n', 'z', '$', 'w', 'd')

    GROUP BY 1,2,4
ORDER BY 2
)a