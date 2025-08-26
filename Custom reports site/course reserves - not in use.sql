/*
Jeremy Goldstein
Minuteman Library Network

Finds bib records used for course reserves that are no longer in use
Is passed owning location as a variable
*/

SELECT
  *,
  '' AS "Course Reserves: Not In Use",
  '' AS "https://sic.minlib.net/reports/19"
FROM (
  SELECT 
    DISTINCT rmb.record_type_code||rmb.record_num||'a' AS bib_number,
    rmi.record_type_code||rmi.record_num||'a' AS item_number,
    i.location_code AS LOCATION,
    bp.best_title AS title,
    TO_DATE(SUBSTRING(note.field_content,1,8), 'mm-dd-yy') AS off_reserve_date,
    SPLIT_PART(SPLIT_PART(note.field_content, ' CIRCED',1), 'FOR ', 2) AS course

  FROM sierra_view.item_record AS i
  JOIN sierra_view.bib_record_item_record_link AS bi
    ON i.id = bi.item_record_id
  JOIN sierra_view.bib_record AS b
    ON bi.bib_record_id = b.id
  LEFT JOIN sierra_view.course_record_item_record_link AS ci
    ON i.id = ci.item_record_id
  JOIN sierra_view.bib_record_property bp
    ON b.id = bp.bib_record_id
  JOIN sierra_view.record_metadata rmi
    ON i.id = rmi.id
  JOIN sierra_view.record_metadata rmb
    ON bi.bib_record_id = rmb.id
  LEFT JOIN sierra_view.varfield note
    ON i.id = note.record_id
    AND note.varfield_type_code = 'r'
  
  WHERE ci.course_record_id IS NULL
    AND b.bcode3 = 'r'
    AND i.location_code ~ '{{Location}}'
    --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
    AND note.field_content LIKE '%OFF RESERVE%'

  ORDER BY 2,3
)a