/*
Jeremy Goldstein & Jenn Del Cegno
Minuteman Library Network
Lazy way to generate curated book list for website
www.minlib.net
challenged books centered on Pride month
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
sierra_view.bib_view v
ON
b.bib_record_id = v.id AND
v.record_num IN (
'3109952',
'1892670',
'3998609',
'3019067',
'3907290',
'3821423',
'3711116',
'3175718',
'2970234',
'3271484',
'3132230',
'3914382',
'3891181',
'3775844',
'3809984',
'3946161',
'3936164',
'3915959',
'2609573',
'3175085',
'4104720',
'2972974',
'2012113',
'2292844',
'3019477',
'3997640',
'3114138',
'3987401',
'3018316',
'3950721',
'4069164',
'3858974',
'3864614',
'3540327',
'2874010',
'2603916',
'3663521',
'4107910',
'4086496',
'3989328',
'3097710',
'3454781',
'3862787',
'3833186',
'2946524',
'2727656',
'3771588',
'3895873',
'2657473',
'3838779',
'3715204',
'3781543',
'3470613',
'3679439',
'3867980',
'3134527',
'2113961',
'3426702',
'4047178',
'3741050',
'3155054',
'2980882',
'3170262',
'3771680',
'3856206',
'3606909',
'3268937',
'3057812',
'3473690',
'3726087',
'3996092',
'2783733',
'3228163',
'3229677',
'3789752',
'3997648',
'3711840',
'2434411',
'3178355',
'2422556',
'3995833',
'2150234',
'3655758',
'3155414',
'3908208',
'1514632',
'3974353',
'1505383',
'3096927',
'3612715',
'3767787',
'2928270',
'3800632',
'3784110',
'3886577',
'3919836',
'3716774',
'3800621',
'3056728',
'3855448',
'3827726',
'2565568',
'3626588',
'3809717',
'2768517',
'1459306',
'3878256',
'3968921',
'3151472',
'2516108',
'2895507',
'3436948',
'3618795',
'3713452',
'3921379',
'3274110',
'3860506',
'2129965',
'2432975',
'2740158',
'3804935',
'3058027'
)
WHERE b.material_code ='a'
GROUP BY 1,2,3 ) a
ORDER BY RANDOM()
LIMIT 75;