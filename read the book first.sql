--Lazy way to generate staff picks booklist
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
--Films
--Nancy Drew and the Hidden Staircase
'1991518',
--Infinite
'3995130',
--those who wish me dead
'3137743',
--Death on the Nile
'2917379',
--Dune
'1495014',
--Deep Water
'2178263',
--Black Widow
'3410594',
--Eternals
'3858608',
--Blonde
'1908073',
--The Nightingale
'3187187',
--Nightmare Alley
'2891526',
--Without Remorse
'1461086',
--woman in the window
'3650356',
--Shang-Chi
'3749678',
--Suicide Squad
'3426716',
--boy called christmas
'3563957',
--Passing
'2693833',
--TV
--Umbrella Academy
'2588224',
--Lovecraft Country
'3451427',
--underground railroad
'3491331',
--mysterious benedict society
'2467715',
--lisey's story
'2406908',
--all creatures great and small
'3168726',
--Batwoman
'2742916',
--His Dark Materials
'2964361',
--Expatriates
'3284483',
--wheel of time
'1208377',
--The witcher
'2584155',
--Lupin
'3777924',
--Bone Collector
'1600077',
--Y the last Man
'3001999',
--Locke & Key
'2621071',
--Snow Piercer
'3146873',
--Loki
'3891151',
--shadow and bone
'2998490',
--Nine Perfect Strangers
'3766686'
)
WHERE b.material_code ='a'
GROUP BY 1,2,3 
ORDER BY RANDOM()
;
