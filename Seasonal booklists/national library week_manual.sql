--Lazy way to generate staff picks booklist
SELECT
--link to Encore
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title as title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) as field_booklist_entry_author,
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
'1910350',
'2840468',
'1613976',
'3098399',
'1945564',
'1512594',
'2467671',
'2515002',
'3205664',
'3411509',
'3234471',
'2572221',
'3111696',
'1766965',
'2590210',
'3120644',
'3162504',
'2466106',
'3147845',
'2450133',
'3184170',
'1938502',
'1472426',
'3095951',
'1294252',
'1994150',
'2041797',
'2656870',
'3732747',
'1990896',
'1954987',
'2144122',
'2994847',
'3732709',
'2196983',
'2749303',
'2476509',
'3767324',
'2109247',
'3679238',
'3237798',
'2463811',
'3435912',
'2586523',
'2723094',
'3411509',
'3225222',
'3240020',
'2775962'

)
WHERE b.material_code ='a'
GROUP BY 1,2,3 
ORDER BY 2 Desc
LIMIT 25;
