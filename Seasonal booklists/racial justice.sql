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
sierra_view.bib_view v
ON
b.bib_record_id = v.id AND
v.record_num IN (
'3670946',
'3882167',
'3812491',
'3909741',
'3850987',
'3465878',
'3817182',
'3873204',
'3622725',
'3886114',
'3640644',
'3133467',
'3176857',
'3855448',
'2496846',
'3814295',
'3651336',
'3661398',
'3825839',
'3763550',
'3855796',
'3711840',
'3602957',
'3271484',
'3817473',
'3478244',
'2248922',
'3672263',
'3727295',
'3651573',
'3663573',
'3659243',
'3740632',
'3770482',
'3768257',
'3278520',
'3100929',
'3716496',
'3804935',
'3670946',
'3857921',
'3858467',
'3725843',
'3431737',
'3782645',
'2882519',
'3723594',
'3177016',
'2979461'
)
GROUP BY b.bib_record_id,1,2,b.material_code 
) a
ORDER BY 1
--LIMIT 50;
;