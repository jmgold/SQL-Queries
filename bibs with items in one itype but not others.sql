--use to gather bibs where a library owns items in a specified itype and no other itypes.

--originally to find instances at Cambridge where there were speed views and not standard dvds.

SELECT
    b.record_type_code || b.record_num || 'a' AS "Bib Record",
    b.title                            AS "Title"
FROM
    sierra_view.bib_view b
WHERE NOT EXISTS (
   SELECT l.id   
   FROM  
      sierra_view.bib_record_item_record_link l
      JOIN   sierra_view.item_view i ON l.item_record_id = i.id
   WHERE  b.id = l.bib_record_id AND i.itype_code_num != '23' AND location_code LIKE 'ntn%'
   )
   AND EXISTS (
   SELECT l.id   
   FROM  
      sierra_view.bib_record_item_record_link l
      JOIN   sierra_view.item_view i ON l.item_record_id = i.id
   WHERE  b.id = l.bib_record_id AND i.itype_code_num = '23' AND location_code LIKE 'ntn%'
   )
ORDER BY "Bib Record";