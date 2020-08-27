/*
Jeremy Goldstein
Minuteman Library Network

Takes the contents of a review file and produces a list of fields for each record appropriate for including in an online booklist.
Designed for non-roman records and will use the contents of the 880 fields for author and title when such fields exist.
*/

SELECT
DISTINCT(REGEXP_REPLACE(i.call_number,'\|[a-z]',' ','g')) AS call_number,
CASE
	WHEN vt.field_content IS NULL THEN b.best_title
	ELSE REGEXP_REPLACE(SUBSTRING(vt.field_content FROM 11),'\|[a-z]',' ','g')
END AS title,
b.best_title AS title_english,
CASE
	WHEN va.field_content IS NULL THEN REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1)
	ELSE REPLACE(SPLIT_PART(SPLIT_PART(REGEXP_REPLACE(SUBSTRING(va.field_content FROM 11),'\|[a-z]',' ','g'),' (',1),', ',2),'.','')||' '||SPLIT_PART(REGEXP_REPLACE(SUBSTRING(va.field_content FROM 11),'\|[a-z]',' ','g'),', ',1)
END AS author,
b.best_author AS author_english,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS url,
(SELECT
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1) AS cover_url

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
JOIN
sierra_view.item_record_property i
ON
sb.record_metadata_id = i.item_record_id
LEFT JOIN
sierra_view.varfield vt
ON
b.bib_record_id = vt.record_id AND vt.marc_tag = '880' AND vt.field_content ~ '^/|6245'
LEFT JOIN
sierra_view.varfield va
ON
b.bib_record_id = va.record_id AND va.marc_tag = '880' AND va.field_content ~ '^/|6100'

WHERE sb.bool_info_id = '513'
--GROUP BY b.bib_record_id,1,2,3,b.material_code 
ORDER BY 1 Desc
