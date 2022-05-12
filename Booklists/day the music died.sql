/*
Jeremy Goldstein
Minuteman Library Newtork

Used to generate booklist at www.minlib.net
*/
(SELECT *
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title AS title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) AS field_booklist_entry_author,
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
sierra_view.varfield_view v1
ON
b.bib_record_id = v1.record_id AND v1.varfield_type_code = 'a' 
AND (v1.field_content LIKE '|aHolly, Buddy,|d1936-1959%' OR v1.field_content LIKE '|aValens, Ritchie,|d1941-1959%' OR v1.field_content LIKE '|aBig Bopper,|d1930-1959%')
--Grab UPC for cover images
LEFT JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '024' AND s.tag = 'a'
WHERE
b.material_code = 'j' -- AND b.publish_year >= '1990'
GROUP BY 1,2,3) a
ORDER BY RANDOM())
UNION
(SELECT *
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
--Limit to Adult collections
AND SUBSTRING(i.location_code,4,1) NOT IN ('j', 'y')
JOIN
sierra_view.varfield_view v2
ON
b.bib_record_id = v2.record_id AND v2.varfield_type_code = 'b' 
AND (v2.field_content LIKE '|aHolly, Buddy,|d1936-1959%' OR v2.field_content LIKE '|aValens, Ritchie,|d1941-1959%' OR v2.field_content LIKE '|aBig Bopper,|d1930-1959%')
--Grab UPC for cover images
LEFT JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '024' AND s.tag = 'a'
WHERE
b.material_code = 'j' -- AND b.publish_year >= '1990'
GROUP BY 1,2,3) a
ORDER BY RANDOM()
LIMIT 50);
