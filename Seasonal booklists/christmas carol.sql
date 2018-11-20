/*
Jeremy Goldstein
Minuteman Library Newtork

Used to generate booklist at www.minlib.net
Originally used in 2018 for 175th anniversary of A Christmas Carol's publication
*/
SELECT *
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
B.best_title as title,
B.best_author as field_booklist_entry_author,
--Generate cover image from Syndetics
'https://syndetics.com/index.aspx?upc='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
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
--AND
--i.is_available_at_library = 'TRUE'
AND i.item_status_code NOT IN ('m', 'n', 'z', 't', 'o', '$', '!', 'w', 'd', 'p', 'r', 'e', 'j', 'u', 'q', 'x', 'y', 'v')
--Grab UPC for cover image
LEFT JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '024' AND s.tag = 'a'
WHERE
--Limit to dvd and blu-ray
b.material_code IN ('5','u') AND b.publish_year >= '1990'
AND
(b.best_title LIKE '%Christmas carol%' OR b.best_title LIKE '%Scrooge%')
GROUP BY 1,2,3) a
ORDER BY RANDOM()
LIMIT 40;