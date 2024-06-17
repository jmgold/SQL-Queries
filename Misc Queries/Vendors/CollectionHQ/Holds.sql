SELECT
  rm.record_type_code||rm.record_num AS bib_id,
  h.pickup_location_code,
  STRING_AGG(SUBSTRING(num.content FROM '[0-9xX]+'),';') FILTER(WHERE num.marc_tag = '020') AS isbn,
  STRING_AGG(num.content,';') FILTER(WHERE num.marc_tag = '022') AS issn,
  STRING_AGG(SUBSTRING(num.content FROM '[0-9]+'),';') FILTER(WHERE num.marc_tag = '024') AS upc,
  --current holds
  b.best_author AS author,
  b.best_title AS title,
  b.publish_year,
  mp.name AS format

FROM sierra_view.hold h
JOIN sierra_view.bib_record_item_record_link l
  ON h.record_id = l.item_record_id OR h.record_id = l.bib_record_id
JOIN sierra_view.bib_record_property b
  ON l.bib_record_id = b.bib_record_id
JOIN sierra_view.record_metadata rm
  ON b.bib_record_id = rm.id
JOIN sierra_view.material_property_myuser mp
  ON b.material_code = mp.code
LEFT JOIN sierra_view.subfield num
  ON b.bib_record_id = num.record_id AND num.marc_tag IN ('020','022','024') AND num.tag = 'a'

WHERE h.pickup_location_code ~ '^na'  
GROUP BY 1,2,6,7,8,9