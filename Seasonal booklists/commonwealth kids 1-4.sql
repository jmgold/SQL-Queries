SELECT *
FROM(
SELECT
--link to Encore, removed in favor of default keyword search on title
--'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title AS title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) AS field_booklist_entry_author,
(SELECT
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1) AS field_booklist_entry_cover

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
--Barbie
'2335686',
--Beauty & the Beast
'3489866',
--Blaze & the Monster Machines
'3538017',
--cat in the hat
'1542261',
--Charlotte's web
'1388986',
--Corduroy
'1148661',
--Creepy pair of Underwear
'3649075',
--fancy nancy
'3224156',
--Freight Train
'2101591',
--Gigantasaurus
'2601746',
--Gingerbread Baby
'1904114',
--goodnight monkey boy
'2010625',
--goodnight hockey fans
'3657091',
--goodnight hockey
'3474759',
--green eggs and ham
'1542262',
--jamberry
'1117110',
--let's go for a drive
'2980939',
--little blue truck
'2568284',
--Marvel Little Golden Book
'3212309',
--Mickey Mouse
'3769518',
--my little pony
'3482242',
--paw patrol
'3309591',
--Pete the Cat
'3271232',
--pigeon finds a hot dog
'2223159',
--pinkalicious
'2413133',
--Poppleton
'1604322',
--Puppy Pals
'3482053',
--red truck
'2555562',
--Scooby Doo and the Snow Monster
'1863878',
--sing
'3073427',
--snow bear
'2280378',
--superhero abc
'2781873',
--the monster at the end of this book
'2242182',
--nightmare before christmas
'2861014',
--thank you book
'3455676',
--very hungry caterpillar
'1088593',
--tickle monster
'2900572',
--uni the unicorn
'3175790',
--welcome to ryans world
'3870968',
--where do diggers sleep at night
'2981067'
)
GROUP BY b.bib_record_id,1,2,b.material_code 
) a
ORDER BY 1
;
