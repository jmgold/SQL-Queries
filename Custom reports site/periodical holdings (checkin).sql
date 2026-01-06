/*
Jeremy Goldstein
Minuteman Library Network
Gathers list of titles for which there are holdings/checking records
Retrieves the location, copy count from the checkin record and holdings varfield
*/
SELECT 
  *,
  '' AS "PERIODICAL HOLDINGS (CHECKIN)",
  '' AS "https://sic.minlib.net/reports/105"

FROM (
  SELECT
    rm.record_type_code||rm.record_num||'a' AS bib_num,
    bp.best_title AS title,
    STRING_AGG(DISTINCT(hl.location_code), ',') AS checkin_rec_location,
    SUM(hl.copies) AS checkin_rec_copies,
    v.field_content AS checkin_rec_holdings

  FROM sierra_view.bib_record_property bp
  JOIN sierra_view.bib_record_holding_record_link bh
    ON bp.bib_record_id = bh.bib_record_id
  JOIN sierra_view.holding_record h
    ON bh.holding_record_id = h.id
  JOIN sierra_view.record_metadata rm
    ON bp.bib_record_id = rm.id
  JOIN sierra_view.holding_record_location hl
    ON h.id = hl.holding_record_id
  LEFT JOIN sierra_view.varfield v
    ON h.id = v.record_id
	 AND varfield_type_code = 'h'

  --limited to periodical format
  WHERE bp.material_code = '3'
    -- enter accounting unit number in place of {{location}}
    AND h.accounting_unit_code_num = '{{location}}'

  GROUP BY 1,2,5
  ORDER BY 2
)a