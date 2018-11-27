--Lazy way to generate staff picks booklist
SELECT
--link to Encore
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author as field_booklist_entry_author,
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
--an unkindness of ghosts
'3661398',
--moonshine
'3613569',
--vacationland
'3652176',
--how to invent everything
'3769049',
--Snagglepuss Chronicles
'3783294',
--Old Woman Laura
'3770952',
--Hawkeye kate bishop
'3718917',
--Spinning Silver
'3755652',
--Isola
'3769849',
--Batman White Knight
'3768360',
--Infidel
'3766670',
--Mae
'3613565',
--Thor
'3755259',
--Metal
'3742087',
--Rock Candy Mountain
'3716159',
--Lost Light
'3754936',
--Doctor Aphra
'3673175',
--Giant Days
'3429620',
--Head Lopper
'3721269',
--Wicked + Divine
'3748062',
--fall of the batmen
'3784606',
--Space Opera
'3725134',
--Freeze Frame Revolution
'3748734',
--Calculating Stars
'3754471'
)
WHERE b.material_code ='a'
GROUP BY 1,2,3 
ORDER BY 2 Desc
LIMIT 25;