/*
Jeremy Goldstein
Minuteman Library Network
Pulls together holding record tables into a single data extract
*/

/*
holding_location CTE used to provide a location filter that will still return all location value
for cases where a record includes multiple location values 
*/

WITH holding_location AS (
  SELECT
    DISTINCT loc.holding_record_id AS id

  FROM sierra_view.holding_record_location loc

  WHERE loc.location_code ~ '{{location}}'
  --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
)

SELECT
  *,
  '' AS "Holding (Checkin) Data",
  '' AS "https://sic.minlib.net/reports/79"

FROM (
  SELECT
    DISTINCT h.id,
    rm.record_type_code,
    rm.record_num,
    rm.creation_date_gmt,
    rm.num_revisions,
    rm.record_last_updated_gmt,
    rm.previous_last_updated_gmt,
    h.accounting_unit_code_num,
    an.name AS accounting_unit_name,
    h.scode1,
    s1.name AS scode1_name,
    h.scode2,
    s2.name AS scode2_name,
    h.scode3,
    s3.name AS scode3_name,
    h.scode4,
    s4.name AS scode4_name,
    h.claimon_date_gmt,
    h.receiving_location_code,
    h.vendor_code,
    vn.field_content AS vendor_record_name,
    h.update_cnt,
    h.piece_cnt,
    h.is_suppressed,
    STRING_AGG(loc.location_code,',') AS location_codes,
    STRING_AGG(l.name,',') AS location_names

  FROM holding_location hl
  JOIN sierra_view.holding_record h
    ON hl.id = h.id
  --Include to limit results to the contents of a review file containing order records
  {{#if include_review_file}}
  JOIN sierra_view.bool_set bs
    ON h.id = bs.record_metadata_id
	 AND bs.bool_info_id = {{review_file}}
  {{/if include_review_file}}
  JOIN sierra_view.record_metadata rm
    ON h.id = rm.id
  JOIN sierra_view.accounting_unit a
    ON h.accounting_unit_code_num = a.code_num
  JOIN sierra_view.accounting_unit_myuser an
    ON a.code_num = an.code
  JOIN sierra_view.vendor_record v
    ON h.vendor_code = v.code
	 AND h.accounting_unit_code_num = v.accounting_unit_code_num
  JOIN sierra_view.varfield vn
    ON v.id = vn.record_id
	 AND vn.varfield_type_code = 't'
  JOIN sierra_view.user_defined_scode1_myuser s1
    ON h.scode1 = s1.code
  JOIN sierra_view.user_defined_scode2_myuser s2
    ON h.scode2 = s2.code
  JOIN sierra_view.user_defined_scode3_myuser s3
    ON h.scode3 = s3.code
  JOIN sierra_view.user_defined_scode4_myuser s4
    ON h.scode4 = s4.code
  JOIN sierra_view.holding_record_location loc
    ON h.id = loc.holding_record_id
  JOIN sierra_view.location_myuser l
    ON loc.location_code = l.code


GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
)a