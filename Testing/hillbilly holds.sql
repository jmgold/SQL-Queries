SELECT
t.transaction_gmt AS transaction_time,
rm.record_type_code||rm.record_num||'a' AS bnumber,
t.patron_home_library_code AS home_library_code

FROM sierra_view.circ_trans t
JOIN sierra_view.bib_record_property b
  ON t.bib_record_id = b.bib_record_id
  AND t.op_code ~ '^n'
  AND b.best_author_norm ~ '^vance j d'
JOIN sierra_view.record_metadata rm
  ON b.bib_record_id = rm.id
JOIN sierra_view.material_property_myuser mat
  ON b.material_code = mat.code
  
ORDER BY 1