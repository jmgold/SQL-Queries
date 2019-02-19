/*
Jeremy Goldstein
Minuteman Library Network

Returns 50 most recently added Ovedrive e-books for booklist at www.minlib.net
*/

SELECT
--link to Encore
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title AS title,
SPLIT_PART(b.best_author,', ',1)||', '||REPLACE(TRANSLATE(SPLIT_PART(b.best_author,', ',2),'.',','),',','') AS field_booklist_entry_author,
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM
sierra_view.bib_record_property b
--Grab ISBN for cover image
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
--Limit to Overdrive records
JOIN sierra_view.subfield s2
ON
b.bib_record_id = s2.record_id AND s2.marc_tag = '710' AND s.tag = 'a' AND s2.content = 'OverDrive, Inc.'
JOIN sierra_view.bib_record_item_record_link bi
ON
b.bib_record_id = bi.bib_record_id
JOIN sierra_view.record_metadata m
ON
bi.item_record_id = m.id AND m.creation_date_gmt > (localtimestamp - interval '7 days')
--Limit to e-book mattype
WHERE b.material_code ='h'
GROUP BY 1,2,3 
ORDER BY 1 Desc
LIMIT 50;