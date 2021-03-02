/*
Jeremy Goldstein
Minuteman Library Network
Lazy way to generate Banned book week list for website
www.minlib.net
*/
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
'1432658',
'1699028',
'2045338',
'2207658',
'2329503',
'2661547',
'2772880',
'2842144',
'2936459',
'2964411',
'2966896',
'2968361',
'2969396',
'3014413',
'3037189',
'3041500',
'3043936',
'3053058',
'3053180',
'3153881',
'3163245',
'3172309',
'3184458',
'3196165',
'3239836',
'3270288',
'3473016',
'3482159',
'3489403',
'3489997',
'3521905',
'3524871',
'3528963',
'3537586',
'3540491',
'3561203',
'3592956',
'3592959',
'3608532',
'3621247',
'3622800',
'3639275',
'3640637',
'3651519',
'3651887',
'3654666',
'3657322',
'3658776',
'3715097',
'3715143',
'3718712',
'3719570',
'3720869',
'3726447',
'3727284',
'3734506',
'3737987',
'3740793',
'3747771',
'3758772',
'3763441',
'3764173',
'3765485',
'3767327',
'3768250',
'3772505',
'3775024',
'3783034',
'3789948',
'3790230',
'3790240',
'3800456',
'3801646',
'3808428',
'3809052',
'3809787',
'3814082',
'3819101',
'3832559',
'3838052',
'3843928',
'3854880',
'3862878',
'3863464',
'3866558',
'3867711',
'3867951',
'3867956',
'3872650',
'3879216',
'3879311',
'3884441',
'3885277',
'3887248',
'3887261',
'3888169',
'3892766',
'3893387',
'3895929',
'3900211',
'3900422',
'3900499',
'3902573',
'3903405',
'3918728',
'3919180',
'3921402',
'3934661'

)
WHERE b.material_code ='a'
GROUP BY 1,2,3 
ORDER BY RANDOM()
LIMIT 50;
