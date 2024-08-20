/*
Jeremy Goldstein
Minuteman Library Network

use to gather bibs where a library owns items in a specified itype and no other itypes.
originally to find instances at Cambridge where there were speed views and not standard dvds, which violates local circ policy.
*/

SELECT
   rm.record_type_code||rm.record_num||'a' AS bib_number,
   b.best_title AS Title
FROM
sierra_view.bib_record_property b
JOIN sierra_view.record_metadata rm
ON b.bib_record_id = rm.id

WHERE NOT EXISTS (
   SELECT l.id   
   
   FROM  
   sierra_view.bib_record_item_record_link l
   JOIN
	sierra_view.item_record i
	ON l.item_record_id = i.id
	
   --limit to location 
	 
   WHERE  b.bib_record_id = l.bib_record_id AND i.itype_code_num != '23' AND i.location_code ~ '^ntn'
   )
   AND EXISTS (
   SELECT l.id   
   
	FROM  
   sierra_view.bib_record_item_record_link l
   JOIN
	sierra_view.item_record i
	ON l.item_record_id = i.id
   --limit to same location as above   
   WHERE  b.bib_record_id = l.bib_record_id AND i.itype_code_num = '23' AND location_code ~ '^ntn'
   )
   
ORDER BY 1
