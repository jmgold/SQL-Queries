/*
Jeremy Goldstein
Minuteman Library Network

Used with reports website to generate a booklist from the contents of a review file

Passed a review file number as a variable
*/

SELECT
--link to Encore
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS encore_url,
b.best_title as title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) as author


FROM
sierra_view.bool_info bo
JOIN
sierra_view.bool_set sb
ON
bo.id = sb.bool_info_id
LEFT JOIN
sierra_view.bib_record_item_record_link bi 
ON
sb.record_metadata_id = bi.item_record_id AND bo.record_type_code = 'i'
LEFT JOIN
sierra_view.bib_record_order_record_link bol
ON sb.record_metadata_id = bol.order_record_id AND bo.record_type_code = 'o'
JOIN
sierra_view.bib_record_property b
ON
(sb.record_metadata_id = b.bib_record_id AND bo.record_type_code ='b') OR bi.bib_record_id = b.bib_record_id OR bol.bib_record_id = b.bib_record_id

WHERE sb.bool_info_id = {{review_file}}
GROUP BY b.bib_record_id,1,2,3,b.material_code 
ORDER BY 2 Desc