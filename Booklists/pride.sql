--Pride month booklist
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
'3731770',
'2496846',
'3243174',
'3734304',
'3723514',
'3230571',
'3621921',
'3602021',
'1910906',
'3470143',
'3201402',
'2041771',
'3428464',
'3630611',
'3489079',
'3139016',
'3735177',
'3159061',
'3608693',
'3055561',
'3646951',
'1830970',
'3715878',
'2966864',
'2889413',
'1014087',
'2894711',
'3534273',
'1420523',
'2736295',
'3739101',
'1957966',
'3679826',
'3127731',
'3739100',
'3678653',
'3466601',
'3653799',
'3750135',
'3625805',
'3716177',
'3739094',
'3761390',
'3769342',
'3759674',
'3770396',
'3764175',
'3778460',
'3747754'
)
WHERE b.material_code ='a'
GROUP BY 1,2,3 
ORDER BY RANDOM()
LIMIT 25
;