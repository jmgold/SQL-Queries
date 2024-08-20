/*
Jeremy Goldstein
Minuteman Library Network
*/

SELECT
  rm.record_type_code||rm.record_num AS "BibNum",
  STRING_AGG(SUBSTRING(num.content FROM '[0-9xX]+'),';' ORDER BY num.occ_num) FILTER(WHERE num.marc_tag = '020') AS isbn,
  STRING_AGG(num.content,';' ORDER BY num.occ_num) FILTER(WHERE num.marc_tag = '022') issn,
  STRING_AGG(SUBSTRING(num.content FROM '[0-9]+'),';' ORDER BY num.occ_num) FILTER(WHERE num.marc_tag = '024') AS upc,
  mp.name AS "MaterialType",
  b.best_title,
  b.best_author,
  b.publish_year,
  TRIM(TRAILING ',' FROM pub.content) AS publisher
  
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
LEFT JOIN
sierra_view.subfield num
ON
b.bib_record_id = num.record_id AND num.marc_tag IN ('020','022','024') AND num.tag = 'a'
JOIN
sierra_view.material_property_myuser mp
ON
b.material_code = mp.code

--Pull full list on Fridays, Delta files other days
WHERE
CASE
  WHEN EXTRACT(DOW FROM CURRENT_DATE) = 5 THEN rm.record_last_updated_gmt::DATE < CURRENT_DATE
  ELSE rm.record_last_updated_gmt::DATE = CURRENT_DATE - INTERVAL '1 day'
END

GROUP BY 1,5,6,7,8,9