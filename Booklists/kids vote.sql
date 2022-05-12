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
sierra_view.bib_view v
ON
b.bib_record_id = v.id AND
v.record_num IN (
'3245281',
'3184069',
'3478787',
'3176857',
'1615446',
'2426775',
'3101838',
'2521091',
'3063654',
'2483392',
'3491088',
'2663186',
'3182270',
'2477316',
'2377714',
'2381717',
'2602061',
'3230730',
'1843295',
'3608585',
'1931713',
'2600747',
'2924640',
'2172721',
'2470154',
'3274960',
'3102752',
'3400378',
'2321039',
'2650740',
'1446456',
'2016642',
'1111674',
'2374940',
'3479212',
'3804935',
'2950294',
'3204739',
'2335038',
'2760551',
'2146753',
'3171396',
'1712923',
'1465686',
'3175790',
'1088593',
'3238198',
'2700119',
'1604605',
'2971701',
'1265254',
'2966515'
)
GROUP BY b.bib_record_id,1,2,b.material_code,b.best_title_norm
ORDER BY b.best_title_norm