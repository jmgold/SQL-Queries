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
'b3915959',
'b3906746',
'b3907175',
'b4023587',
'b3963524',
'b3940720',
'b3945252',
'b3912429',
'b4018583',
'b3940965',
'b3939989',
'b3940320',
'b3994620',
'b3888646',
'b3970805',
'b3937964',
'b3879764',
'b3873204',
'b3995397',
'b3913389',
'b3914377'
)
WHERE b.material_code ='a'
GROUP BY 1,2,b.best_title_norm,3 
ORDER BY b.best_title_norm;