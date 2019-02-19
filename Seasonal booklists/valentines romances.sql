/*
Jeremy Goldstein
Minuteman Library Newtork

Used to generate booklist at www.minlib.net
Originally run in 2018 for 50th anniversary of Apollo missions
*/
SELECT
'http://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS "field_booklist_entry_encore_url",
b.best_title AS title,
SPLIT_PART(b.best_author,', ',1)||', '||REPLACE(TRANSLATE(SPLIT_PART(b.best_author,', ',2),'.',','),',','') AS field_booklist_entry_author,
--Generate cover image from Syndetics
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
sierra_view.bib_record_item_record_link bi
ON
b.bib_record_id = bi.bib_record_id
JOIN
sierra_view.item_record i
ON
bi.item_record_id = i.id AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')
AND i.item_status_code NOT IN ('m', 'n', 'z', 't', 'o', '$', '!', 'w', 'd', 'p', 'r', 'e', 'j', 'u', 'q', 'x', 'y', 'v')
JOIN
sierra_view.phrase_entry d
ON
b.bib_record_id = d.record_id AND d.varfield_type_code = 'd'
AND REPLACE(d.index_entry, ' ', '') LIKE '%romancefiction%'
WHERE
b.publish_year = '2018' AND b.material_code = 'a'
GROUP BY 1,2,3,4
ORDER BY SUM(i.checkout_total) desc
LIMIT 100