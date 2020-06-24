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
'2966588',
'2510794',
'2900477',
'3110294',
'3767054',
'3756534',
'3854262',
'3785452',
'3650288',
'2250219',
'3742476',
'3826374',
'3769129',
'3788556',
'3078724',
'3182292',
'2168599',
'2700765',
'2470540',
'1606392',
'1528350',
'2130801',
'3031494',
'3764440',
'2711768',
'3853402',
'3755652',
'2142725',
'3526096',
'3656837',
'3234140',
'2871672',
'1921331',
'1872323',
'3659252',
'2197290',
'3785445',
'1934578',
'2662078',
'2761859',
'2538674',
'1979269',
'3175553',
'2996634',
'3223099',
'2148330',
'3723602',
'3800729',
'3901278',
'3910004',
'3909995',
'3916545',
'3562639',
'3916550',
'3910241',
'3913395',
'3912980',
'3223099',
'3115369',
'3822177'
)
GROUP BY b.bib_record_id,1,2,b.material_code 
) a
ORDER BY RANDOM()
LIMIT 50;
;