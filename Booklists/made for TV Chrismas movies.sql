/*
Jeremy Goldstein
Minuteman Library Newtork

Used to generate booklist at www.minlib.net
*/
SELECT *
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title AS title,
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
--Limit to Adult collections
AND SUBSTRING(i.location_code,4,1) NOT IN ('j', 'y')
JOIN
sierra_view.phrase_entry d
ON
b.bib_record_id = d.record_id AND d.varfield_type_code = 'd' 
AND REPLACE(d.index_entry, ' ', '') LIKE '%christmasfilms%'
JOIN
sierra_view.phrase_entry d2
ON
b.bib_record_id = d2.record_id AND d2.varfield_type_code = 'd'  
AND REPLACE(d2.index_entry, ' ', '') LIKE '%madefortv%'
--Grab UPC for cover images
LEFT JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '024' AND s.tag = 'a'
WHERE
b.material_code IN ('5','u') AND b.publish_year >= '1990'
GROUP BY 1,2) a
ORDER BY RANDOM()
LIMIT 50;