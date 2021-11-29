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
--Nancy Drew and the Hidden Staircase
'1991518',
--Infinite
'3995130',
--those who wish me dead
'3137743',
--Black Widow
'3410594',
--Eternals
'3858608',
--Blonde
'1908073',
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
--Umbrella Academy
'2588224',
--mysterious benedict society
'2467715',
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
--The power : a novel / Naomi Alderman
'36568387',
--Beartown : a novel / Fredrik Backman   translated by Neil Smith
'36138745',
--The vanishing half / Brit Bennett
'3904814',
--Good omens : the nice and accurate prophecies of Agnes Nutter, witch / Neil Gaiman, Terry Pratchett
'2384864',
--The silence of the lambs / Thomas Harris
'1178755',
--Lisey's story / Stephen King
'4013251',
--The One : a novel / John Marrs
'4007305',
--Nine perfect strangers / Liane Moriarty
'3766686',
--Little fires everywhere / Celeste Ng
'3639155',
--Pieces of her : a novel / Karin Slaughter
'3845332',
--Fear Street, the beginning / R.L. Stine
'4032527',
--Anatomy of a scandal / Sarah Vaughan
'3650449',
--Gossip girl : a novel / by Cecily von Ziegesar
'2077281',
--The underground railroad : a novel / Colson Whitehead
'3491331',
--The white tiger : a novel / Aravind Adiga
'2619778',
--Sir Gawain and the Green Knight : a new verse translation / [translated by] Simon Armitage
'3226495',
--Dune / Frank Herbert
'4027565',
--Deep water / Patricia Highsmith
'2178263',
--The Power of the Dog
'40500561',
--Shadow of Night / Deborah Harkness
'2975507',
--Death on the Nile
'2917379',
--The Nightingale / Kristin Hannah
'3187187',
--Killers of the Flower Moon
'3725058',
--She Hulk
'3229579',
--Moon Knight
'3282787',
--Doctor Strange
'3483444',
--Thor
'3839588',
--Morbius
'3998876',
--Flashpoint
'2982857',
--Redeeming Love
'4050054',
--Sandman
'3828855',
--Ms Marvel
'3710862',
--White noise
'1917835',
--School for Good and Evil
'3159244',
--House of Gucci
'2478322'
)
WHERE b.material_code ='a'
GROUP BY 1,2,3 
ORDER BY RANDOM()
;
