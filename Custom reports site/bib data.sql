/*
Jeremy Goldstein
Minuteman Library Network
Pulls together bib record tables into a single data extract
*/

SELECT
  b.*,
  STRING_AGG(loc.location_code,', ') AS bib_record_location_codes,
  '' AS "BIB DATA",
  '' AS "https://sic.minlib.net/reports/77"

FROM (
  SELECT
    DISTINCT b.id,
    rm.record_type_code,
    rm.record_num,
    rm.creation_date_gmt,
    rm.campus_code,
    rm.num_revisions,
    rm.record_last_updated_gmt,
    rm.previous_last_updated_gmt,
    b.language_code,
    lang.name AS language_name,
    bp.bib_level_code,
    bl.name AS bib_level_name,
    b.bcode3,
    b3.name AS bcode3_name,
    bp.material_code AS material_type_code,
    mat.name AS material_type_name,
    b.country_code,
    b.is_on_course_reserve,
    b.skip_num,
    b.cataloging_date_gmt,
    b.is_suppressed,
    bp.publish_year,
    bp.best_title,
    bp.best_title_norm,
    bp.best_author,
    bp.best_author_norm

  FROM sierra_view.bib_record b
  JOIN sierra_view.bib_record_location loc
    ON b.id = loc.bib_record_id
  /*{{#if include_review_file}}
  JOIN sierra_view.bool_set bs
    ON b.id = bs.record_metadata_id
	 AND bs.bool_info_id = {{review_file}}
  {{/if include_review_file}}*/
  JOIN sierra_view.bib_record_property bp
    ON b.id = bp.bib_record_id
  JOIN sierra_view.record_metadata rm
    ON b.id = rm.id
  JOIN sierra_view.language_property_myuser lang
    ON b.language_code = lang.code
  JOIN sierra_view.bib_level_property_myuser bl
    ON bp.bib_level_code = bl.code
  JOIN sierra_view.user_defined_bcode3_myuser b3
    ON b.bcode3 = b3.code
  JOIN sierra_view.material_property_myuser mat
    ON bp.material_code = mat.code

  WHERE loc.location_code ~ '{{location}}'
  --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
)b
JOIN sierra_view.bib_record_location loc
  ON b.id = loc.bib_record_id

GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,28,29