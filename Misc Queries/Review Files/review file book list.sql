/*
Jeremy Goldstein
Minuteman Library Network

Used with reports website to generate a booklist from the contents of a review file
*/

SELECT
--link to Encore
--'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS url,
-- link to Aspen
'https://catalog.minlib.net/Record/'||id2reckey(b.bib_record_id) AS url, 
b.best_title as title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) AS author,
CASE
WHEN b.material_code IN ('a','2','3','9','c','e')
THEN (SELECT
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1)
WHEN b.material_code NOT IN ('a','2','3','9','c','e')
THEN (SELECT
'https://syndetics.com/index.aspx?upc='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '024' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1)
END AS cover_img

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

WHERE sb.bool_info_id ='114'
GROUP BY b.bib_record_id,1,2,3,b.material_code 
ORDER BY 2 Desc
