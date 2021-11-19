SELECT
rm.record_type_code||rm.record_num||'a' AS bnumber,
b.best_title AS title,
COALESCE(REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1),'') AS author,
b.publish_year,
STRING_AGG(DISTINCT i.location_code,',') AS location
--,COALESCE(REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1),'')||' '||b.best_title AS match_point

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
JOIN
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id
WHERE
b.material_code = 'a'
AND b.publish_year >= 2018
AND i.location_code ~ '^ntn'

GROUP BY 1,2,3,4
ORDER BY 2,3