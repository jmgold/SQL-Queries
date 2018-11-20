/*
Jeremy Goldstein
Minuteman Library Newtork

Used to generate booklist at www.minlib.net
Originally run in 2018 for 50th anniversary of Apollo missions
*/
SELECT
'http://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS "field_booklist_entry_encore_url",
best_title as title,
best_author as field_booklist_entry_author,
--Generate cover image from Syndetics
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM
sierra_view.bib_record_property b
--Grab ISBN for cover image
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
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
sierra_view.varfield_view v
ON
b.bib_record_id = v.record_id AND v.varfield_type_code = 'd' 
--Limit to a subject
AND v.field_content LIKE '%Romance fiction%'
WHERE
b.publish_year = '2018' AND b.material_code = 'a'
GROUP BY 1,2,3
ORDER BY SUM(i.checkout_total) desc
LIMIT 100