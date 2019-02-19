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
b.best_title as title,
SPLIT_PART(b.best_author,', ',1)||', '||REPLACE(TRANSLATE(SPLIT_PART(b.best_author,', ',2),'.',','),',','') as field_booklist_entry_author,
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
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
AND
i.is_available_at_library = 'TRUE'
AND i.item_status_code NOT IN ('m', 'n', 'z', 't', 'o', '$', '!', 'w', 'd', 'p', 'r', 'e', 'j', 'u', 'q', 'x', 'y', 'v')
--Limit to juv or YA collections
AND SUBSTRING(i.location_code,4,1)  IN ('j','y')
JOIN
sierra_view.phrase_entry d
ON
b.bib_record_id = d.record_id AND varfield_type_code = 'd'
AND REPLACE(d.index_entry, ' ', '') LIKE '%juvenileliterature%'
AND (REPLACE(d.index_entry, ' ', '') LIKE '%womenunitedstates%' OR REPLACE(d.index_entry, ' ', '') LIKE '%feminismunitedstates%' OR REPLACE(d.index_entry, ' ', '') LIKE '%womensrightsunitedstates%')
AND NOT (REPLACE(d.index_entry, ' ', '') LIKE '%rape%' OR REPLACE(d.index_entry, ' ', '') LIKE '%violenceagainst%')
WHERE
b.material_code = 'a' AND b.publish_year >= '2012'
GROUP BY 1,2,3,4) a
ORDER BY RANDOM()
LIMIT 50;