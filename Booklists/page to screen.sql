--curated list of books adapted to current film/tv
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
--Blonde
'1908073',
--Umbrella Academy
'2588224',
--mysterious benedict society
'2467715',
--all creatures great and small
'3168726',
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
--Snow Piercer
'3146873',
--Loki
'3891151',
--shadow and bone
'2998490',
--The power : a novel / Naomi Alderman
'36568387',
--Good omens : the nice and accurate prophecies of Agnes Nutter, witch / Neil Gaiman, Terry Pratchett
'2384864',
--Anatomy of a scandal / Sarah Vaughan
'3650449',
--Gossip girl : a novel / by Cecily von Ziegesar
'2077281',
--Dune / Frank Herbert
'4027565',
--Deep water / Patricia Highsmith
'2178263',
--The Power of the Dog
'40500561',
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
--Sandman
'3828855',
--Ms Marvel
'3710862',
--White noise
'1917835',
--School for Good and Evil
'3159244',
--Under the Banner of Heaven
'2158471',
--The Shining Girls
'3053518',
--Firestarter
'3639332',
--conversations with friends
'3638890',
--The Lost Girls
'2185666',
--The Black Phone
'4057836',
--The Terminal List
'3732683',
--Bullet Train
'4020215',
--where the crawdads sing
'3743010',
--Showtime
'3141348',
--Reacher
'3053483',
--Bridgerton 2
'3913438',
--Pachinko
'3619885',
--Heartstopper
'3912429',
--Slow Horses
'39959296'
)
WHERE b.material_code ='a'
GROUP BY 1,2,3 
ORDER BY RANDOM()
;
