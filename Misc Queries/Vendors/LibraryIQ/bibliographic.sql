SELECT
  rm.record_type_code||rm.record_num AS "BibliographicRecordID",
  (SELECT
	COALESCE(STRING_AGG(REGEXP_REPLACE(REPLACE(REGEXP_REPLACE(v.field_content,'(\|a|:)','','g'),'|q',' '),'(\|c|\|2|\|d).*?(\||$)',''),', '),'') AS isbns
	FROM sierra_view.varfield v
	WHERE b.bib_record_id = v.record_id AND v.marc_tag = '020' AND v.field_content !~ '\|z'
  )AS "ISBN",
  (SELECT
	COALESCE(STRING_AGG(REGEXP_REPLACE(REPLACE(REGEXP_REPLACE(v.field_content,'(\|a|:)','','g'),'|q',' '),'(\|c|\|2|\|d).*?(\||$)',''),', '),'') AS isbns
	FROM sierra_view.varfield v
	WHERE b.bib_record_id = v.record_id AND v.marc_tag = '024' AND v.field_content !~ '\|z'
  )AS "UPC",
  b.material_code AS "Material type",
  b.best_title AS "Title",
  b.best_author AS "Author",
  b.publish_year AS "Publication date",
  TRIM(TRAILING ',' FROM pub.content) AS "Publisher"
  
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id
LEFT JOIN
sierra_view.subfield pub
ON
b.bib_record_id = pub.record_id AND pub.marc_tag IN ('260','264') AND pub.tag = 'b'

--use filter for delta file
--WHERE rm.record_last_updated_gmt::DATE = CURRENT_DATE - INTERVAL '1 day'