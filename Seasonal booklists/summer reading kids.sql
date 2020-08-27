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
'3871892',
'3172676',
'3411891',
'2546702',
'3456904',
'3736749',
'3775940',
'3521522',
'3647899',
'3625984',
'3767590',
'3159244',
'3857541',
'2080588',
'3711649',
'3238460',
'3876152',
'3682121',
'2940685',
'3527022',
'3115369',
'3731429',
'3165657',
'3855095',
'3775374',
'3856975',
'3838858',
'2574027',
'3885615',
'3030935',
'3022269',
'3763566',
'3731446',
'3858985',
'3601068',
'3042564',
'3682116',
'3682116',
'3283657',
'3856967',
'3824981',
'3885620',
'3895004',
'2840650',
'3661031',
'3805557',
'3242429',
'3659357',
'3656898',
'3887660',
'3889168',
'3893966',
'3851915',
'3891794',
'3858843',
'2597973',
'2098267',
'3881562',
'3888623',
'3860777',
'3851936',
'3874244',
'3810772',
'3910270',
'3875365',
'3885620',
'3857669'
)
GROUP BY b.bib_record_id,1,2,b.material_code 
) a
ORDER BY RANDOM()
LIMIT 50;
;