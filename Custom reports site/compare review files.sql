/*
Jeremy Goldstein
Minuteman Library Network

Takes two review files to find either unique or duplicate records between them
*/

SELECT
  *,
  '' AS "COMPARE REVIEW FILES",
  '' AS "https://sic.minlib.net/reports/46"
FROM (
  SELECT
    rm.record_type_code||rm.record_num||'a' AS record_number

  FROM sierra_view.bool_set bs
  JOIN sierra_view.record_metadata rm
    ON bs.record_metadata_id = rm.id    

  WHERE bs.bool_info_id = {{review_file_a}}

  {{comparison}}
  --Comparison options are EXCEPT or INTERSECT

  SELECT
    rm.record_type_code||rm.record_num||'a'

  FROM sierra_view.bool_set bs
  JOIN sierra_view.record_metadata rm
    ON bs.record_metadata_id = rm.id   

  WHERE bs.bool_info_id = {{review_file_b}}
)a