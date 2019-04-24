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
--Avengers
'3070708',
--Batgirl
'3242377',
--Batman
'3014471',
--Black Panther
'3432822',
--Captain America
'2887715',
--Captain Marvel
'3528152',
--Cloak and Dagger
'3501398',
--Daredevil
'3049363',
--Deadpool
'2715121',
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
--Hulk
'2578713',
--Iron Man
'2611426',
--Justice League
'3049397',
--Legion
'3081406',
--Ms Marvel
'3184395',
--Power Man & Iron Fist
'3592473',
--Runaways
'3233830',
--Shazam
'3818219',
--Spider Man
'3172738',
--Spider Man Miles
'3412085',
--Suicide Squad
'3426716',
--Supergirl
'3609337',
--Superman
'3599709',
--Teen Titans
'3608601',
--Thor
'3105838',
--Wolverine
'2460750',
--Wonder Woman
'3780288',
--X Men
'2444899'
)
WHERE b.material_code ='a'
GROUP BY 1,2,3 
ORDER BY 2
;