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
'1607907',
'3236069',
'3970120',
'3916555',
'4041449',
'3913075',
'3610886',
'3466216',
'3280433',
'3771640',
'3598917',
'3067455',
'3461360',
'3268956',
'3765859',
'3148592',
'4018571',
'3909870',
'3643921',
'2710164',
'3844855',
'3533832',
'3061064',
'3992487',
'3471875',
'3643431',
'3782948',
'3964720',
'2672864',
'3659992',
'2846899',
'3940720',
'2484859',
'3738471',
'3747513',
'2668716',
'3156091',
'3994631',
'3977856',
'3802817',
'4007192',
'3743047',
'3906535',
'4080910',
'3961724',
'3466216',
'3207336',
'3950147',
'3598917',
'3944484',
'4031757',
'4084062',
'3873205'
)
GROUP BY b.bib_record_id,1,2,b.material_code 
) a
ORDER BY RANDOM()
LIMIT 50;
;