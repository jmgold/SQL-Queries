--Lazy way to generate staff picks booklist
SELECT
--link to Encore
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title as title,
SPLIT_PART(b.best_author,', ',1)||', '||REPLACE(TRANSLATE(SPLIT_PART(b.best_author,', ',2),'.',','),',','') as field_booklist_entry_author,
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM
sierra_view.bib_record_property b
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN sierra_view.bib_record_item_record_link bi
ON
b.bib_record_id = bi.bib_record_id
JOIN
sierra_view.bib_view v
ON
b.bib_record_id = v.id AND
v.record_num IN (
--Transformers: More than Meets the eye
'3187488',
--The Fifth Season
'3272328',
--an unkindness of ghosts
'3661398',
--stars my destination
'2960646',
--wicked + divine
'3211646',
--moonshine
'3613569',
--vacationland
'3652176',
--how to invent everything
'3769049',
--motherless brooklin
'1882244',
--the demon
'3128251',
--Giant Days
'3429620',
--Black Widow
'3595102',
--Thor by Simonson
'3105838',
--Snagglepuss Chronicles
'3783294'
)
WHERE b.material_code ='a'
GROUP BY 1,2,3 
ORDER BY 2 Desc
LIMIT 25;