/*
Jeremy Goldstein
Minuteman Library Network

Takes the contents of a review file and produces a list of fields for each record appropriate for including in an online booklist.
Designed for non-roman records and will use the contents of the 880 fields for author and title when such fields exist.
*/

SELECT
*,
'' AS "REVIEW FILE TO BOOKLIST",
'' AS "https://sic.minlib.net/reports/73"
FROM
(SELECT
DISTINCT(COALESCE(REGEXP_REPLACE(i.call_number,'\|[a-z]',' ','g'), '')) AS call_number,
{{#if include_nonroman}}
CASE
	WHEN vt.field_content IS NULL THEN b.best_title
	ELSE REGEXP_REPLACE(SPLIT_PART(REGEXP_REPLACE(vt.field_content,'^.*\|a',''),'|',1),'\s?(\.|\,|\:|\/|\;|\=)\s?$','')
END AS title_nonroman,
{{/if include_nonroman}}
b.best_title AS title,
{{#if include_nonroman}}
CASE
	WHEN va.field_content IS NULL THEN b.best_author
   ELSE REGEXP_REPLACE(REPLACE(REPLACE(REGEXP_REPLACE(va.field_content,'^.*\|a',''),'|d',' '),'|q',' '),'\s?(\.|\,|\:|\/|\;|\=)\s?$','')
END AS author_nonroman,
{{/if include_nonroman}}
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) AS author,
'https://catalog.minlib.net/Record/'||id2reckey(b.bib_record_id) AS url,
CASE
WHEN b.material_code = 'a'
THEN (SELECT
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1)
WHEN b.material_code != 'a'
THEN (SELECT
'https://syndetics.com/index.aspx?upc='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '024' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1)
END AS cover_url

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
LEFT JOIN
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

WHERE sb.bool_info_id = {{review_file}}
GROUP BY b.bib_record_id,1,b.best_title,b.best_author,b.material_code
{{#if include_nonroman}}
,2,4
{{/if include_nonroman}}
ORDER BY 1,3
)a