/*
Jeremy Goldstein
Minuteman Library Network

New Book list for www.minlib.net
*/
SELECT
--link to Encore
'https://find.minlib.net/iii/encore/record/C__Rb'||mb.record_num   AS field_booklist_entry_encore_url,
b.best_title as title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) AS field_booklist_entry_author,
(SELECT
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1) AS field_booklist_entry_cover
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record br
ON b.bib_record_id = br.id AND br.bcode3 != 'g'
JOIN sierra_view.bib_record_item_record_link bi
ON
b.bib_record_id = bi.bib_record_id
JOIN sierra_view.record_metadata m
ON
bi.item_record_id = m.id AND m.creation_date_gmt > (localtimestamp - interval '4 days')
JOIN
sierra_view.record_metadata mb
ON
b.bib_record_id = mb.id
WHERE b.material_code ='a'
GROUP BY 1,2,3,4 
ORDER BY COUNT(bi.bib_record_id) desc
LIMIT 100;