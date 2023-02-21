SELECT *
FROM(
SELECT
--link to Encore, removed in favor of default keyword search on title
--'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title as title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) as field_booklist_entry_author,
CASE
WHEN b.material_code = 'a'
THEN (SELECT
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1)
WHEN b.material_code != 'a'
THEN (SELECT
'https://syndetics.com/index.aspx?upc='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '024' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1)
END AS field_booklist_entry_cover

FROM
sierra_view.bib_record_property b
JOIN sierra_view.bib_record_item_record_link bi
ON
b.bib_record_id = bi.bib_record_id
JOIN
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id AND
rm.record_type_code||rm.record_num IN (
'b4075541',
'b4084165',
'b4140927',
'b4128031',
'b4045220',
'b4066083',
'b4141828',
'b4106544',
'b4122211',
'b4045224',
'b4083371',
'b4082736',
'b4035804',
'b4066682',
'b4077705',
'b4140573',
'b4120921',
'b4123193',
'b4081300',
'b4113789',
'b4048005',
'b4118182',
'b4134754',
'b4076120',
'b4068581',
'b4064235',
'b4078954',
'b4056580',
'b4057868',
'b4105741',
'b4110235',
'b4132190',
'b4105516',
'b4073900',
'b4082944',
'b4131078',
'b4083936',
'b4055598'

)
GROUP BY b.bib_record_id,1,2,b.material_code 
) a
ORDER BY 1
;