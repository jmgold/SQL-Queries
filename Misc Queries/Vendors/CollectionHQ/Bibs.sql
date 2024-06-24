/*
Jeremy Goldstein
Minuteman Library Network

Gathers bib record data (limited to those associated with a location)
for a regular data upload to CollectionHQ
*/

SELECT
  rm.record_type_code||rm.record_num AS bib_record_num,
  rm.creation_date_gmt::DATE AS creation_date,
  rm.record_last_updated_gmt::DATE AS record_last_updated,
  STRING_AGG(SUBSTRING(num.content FROM '[0-9xX]+'),',') FILTER(WHERE num.marc_tag = '020') AS isbn,
  STRING_AGG(num.content,',') FILTER(WHERE num.marc_tag = '022') AS issn,
  STRING_AGG(SUBSTRING(num.content FROM '[0-9]+'),',') FILTER(WHERE num.marc_tag = '024') AS upc,
  b.best_author AS author,
  b.best_title AS title,
  TRIM(TRAILING ',' FROM pub.content) AS publisher,
  b.publish_year,
  STRING_AGG(sub.index_entry,','ORDER BY sub.occurrence, sub.id) AS subject,
  mp.name AS format
  
FROM sierra_view.bib_record_property b
JOIN sierra_view.bib_record_location bl
  ON b.bib_record_id = bl.bib_record_id AND bl.location_code ~ '^na[^2]'
JOIN sierra_view.record_metadata rm
  ON b.bib_record_id = rm.id
LEFT JOIN sierra_view.subfield num
  ON b.bib_record_id = num.record_id AND num.marc_tag IN ('020','022','024') AND num.tag = 'a'
LEFT JOIN sierra_view.subfield pub
  ON b.bib_record_id = pub.record_id AND pub.marc_tag IN ('260','264') AND pub.tag = 'b'
LEFT JOIN sierra_view.phrase_entry sub
  ON b.bib_record_id = sub.record_id AND sub.varfield_type_code = 'd'
JOIN sierra_view.material_property_myuser mp
  ON b.material_code = mp.code

GROUP BY 1,2,3,7,8,9,10,12