/*
Jeremy Goldstein & Jenn Del Cegno
Minuteman Library Network
Lazy way to generate curated book list for website
www.minlib.net
*/
SELECT *
FROM(
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
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id AND
rm.record_type_code||rm.record_num IN (
'b3426595',
'b3525690',
'b3567287',
'b3451590',
'b3941535',
'b3795845',
'b3112973',
'b3869673',
'b3660374',
'b3227778',
'b3735530',
'b3808464',
'b3429547',
'b3232489',
'b3601900',
'b3480715',
'b3567439',
'b3992419',
'b3205424',
'b3226911',
'b3803056',
'b3939742',
'b3641558',
'b2060923',
'b3735280',
'b3710894',
'b3200248',
'b3622789',
'b3167560',
'b3653509',
'b3888771',
'b3761138',
'b3067907',
'b2502831',
'b3647915',
'b3276272',
'b2059309',
'b3892252',
'b2053518',
'b2555945',
'b1844944',
'b3940581'
)
--WHERE b.material_code ='a'
GROUP BY 1,2,3 ) a
ORDER BY RANDOM()
LIMIT 50;