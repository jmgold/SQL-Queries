/*
Jeremy Goldstein
Minuteman Library Newtork

Used to generate booklist at www.minlib.net
*/
SELECT
'http://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS "field_booklist_entry_encore_url",
b.best_title AS title,
SPLIT_PART(b.best_author,', ',1)||', '||REPLACE(TRANSLATE(SPLIT_PART(b.best_author,', ',2),'.',','),',','') AS field_booklist_entry_author,
--Generate cover image from Syndetics
'https://syndetics.com/index.aspx?upc='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM
sierra_view.bib_record_property b
--Grab UPC for cover image
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '024' AND s.tag = 'a'
JOIN
sierra_view.bib_record_item_record_link bi
ON
b.bib_record_id = bi.bib_record_id
JOIN
sierra_view.item_record i
ON
bi.item_record_id = i.id 
--Limit to Adult colections
AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')
AND i.item_status_code NOT IN ('m', 'n', 'z', 't', 'o', '$', '!', 'w', 'd', 'p', 'r', 'e', 'j', 'u', 'q', 'x', 'y', 'v')
JOIN
sierra_view.bib_record r
ON b.bib_record_id = r.id AND r.language_code = 'eng'
WHERE
b.material_code = '8' and b.publish_year > '1980'
GROUP BY 1,2,3
ORDER BY RANDOM()
LIMIT 100