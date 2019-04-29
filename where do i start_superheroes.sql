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
--Ant Man
'3241596',
--Aquaman
'3027981',
--Astro City
'2930055',
--Avengers
'3070708',
--Batgirl
'3242377',
--Batman
'3014471',
--Black Hammer
'3611973',
--Black Panther
'3432822',
--Black Widow
'3595102',
--Cable
'3068550',
--Captain America
'2887715',
--Captain Marvel
'3528152',
--Catwoman
'3233664',
--Cloak and Dagger
'3501398',
--Daredevil
'3049363',
--Deadpool
'2715121',
--Doctor Strange
'3483445',
--Doom Patrol
'3593410',
--Eternals
'2500576',
--Fantastic Four
'2883512',
--Flash
'2982857',
--Green Arrow
'2585324',
--Green Lantern
'2925679',
--Guardians of the Galaxy
'3164093',
--Harley Quinn
'3184392',
--Hawkeye
'3039950',
--Hellboy
'2599845',
--Hulk
'2578713',
--Inhumans
'2078029',
--Iron Man
'2611426',
--Justice League
'3049397',
--Legion
'3081406',
--Moon Knight
'3220027',
--Ms Marvel
'3184395',
--New Gods
'2514211',
--Nightwing
'3608599',
--Power Man & Iron Fist
'3592473',
--Rocket Raccoon
'3226197',
--Runaways
'3233830',
--Shang Chi
'3749678',
--Shazam
'3818219',
--She Hulk
'3136150',
--Silver Surfer
'3224757',
--Spider Man
'3172738',
--Spider Man Miles
'3412085',
--Squirrel Girl
'3279609',
--Suicide Squad
'3426716',
--Supergirl
'3609337',
--Superman
'3599709',
--Teen Titans
'3608601',
--Thanos
'3101739',
--Thor
'3105838',
--Umbrella Academy
'2588224',
--Venom
'3749682',
--Vision
'3714481',
--Wolverine
'2460750',
--Wonder Woman
'3780288',
--X Men
'2976475'
)
GROUP BY 1,2,3 
ORDER BY 2
;