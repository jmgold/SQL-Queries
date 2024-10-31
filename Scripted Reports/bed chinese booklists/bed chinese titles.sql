/*
Jeremy Goldstein
Minuteman Library Network

Gathers up title information for a booklist for the Chinese language collections at Bedford.
Designed for non-roman records and will use the contents of the 880 fields for author and title when such fields exist.
*/

SELECT
DISTINCT(REGEXP_REPLACE(i.call_number,'\|[a-z]',' ','g')) AS call_number,
CASE
	WHEN vt.field_content IS NULL THEN b.best_title
    ELSE REGEXP_REPLACE(SPLIT_PART(REGEXP_REPLACE(vt.field_content,'^.*\|a',''),'|',1),'\s?(\.|\,|\:|\/|\;|\=)\s?$','')
END AS title,
b.best_title AS title_english,
CASE
	WHEN va.field_content IS NULL THEN REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1)
    ELSE REGEXP_REPLACE(REPLACE(REPLACE(REGEXP_REPLACE(SPLIT_PART(va.field_content,'|e',1),'^.*\|a',''),'|d',' '),'|q',' '),'\s?(\.|\,|\:|\/|\;|\=)\s?$','')
END AS author,
b.best_author AS author_english,
'https://catalog.minlib.net/Record/'||id2reckey(b.bib_record_id) AS url,
(SELECT
SUBSTRING(s.content FROM '[0-9]+')
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1) AS ISBN

FROM
sierra_view.item_record ir
JOIN
sierra_view.record_metadata m
ON
ir.id = m.id --AND m.creation_date_gmt::DATE BETWEEN '2022-07-01' AND '2022-09-30'
JOIN
sierra_view.bib_record_item_record_link bi 
ON
ir.id = bi.item_record_id
JOIN
sierra_view.bib_record_property b
ON
bi.bib_record_id = b.bib_record_id
JOIN
sierra_view.bib_record br
ON
b.bib_record_id = br.id --AND br.language_code = 'chi'
JOIN
sierra_view.item_record_property i
ON
ir.id = i.item_record_id
LEFT JOIN
sierra_view.varfield vt
ON
b.bib_record_id = vt.record_id AND vt.marc_tag = '880' AND vt.field_content ~ '^/|6245'
LEFT JOIN
sierra_view.varfield va
ON
b.bib_record_id = va.record_id AND va.marc_tag = '880' AND va.field_content ~ '^/|6100'

WHERE
ir.location_code ~ '^bed'
--AND ir.icode1 IN ('107','109')
AND ir.icode1 = '109'
--GROUP BY b.bib_record_id,1,2,3,b.material_code 
ORDER BY 1
