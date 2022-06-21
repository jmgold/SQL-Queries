--Lazy way to generate staff picks booklist
SELECT
--link to Encore
--'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
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
--No 1 ladies detective agency
'2111854',
--Amelia Peabody
'3116715',
--Hercule Poirot
'3046946',
--Hannah Swensen
'2440994',
--the cat who
'1609558',
--Gamache
'2940607',
--Nancy Drew
'1792164',
--Miss Marple
'3046989',
--Agatha Raisin
'2394307',
--Hamish Macbeth
'1054872',
--Lord Peter Whimsey
'3206545',
--Her Royal Spyness
'2589473',
--Cadfael
'1486798',
--Maisie Dobbs
'3176386',
--Mary Russell
'1486213',
--Aunt Dimity
'1574900',
--Aurora Teagarden
'2545632',
--China Bayles
'2448997',
--Vicky Bliss
'2646581',
--Thursday Next
'2148729',
--Richard Jury
'2135910',
--Mrs Murphy
'1423660',
--Spellmans
'2454716',
--Phryne Fisher
'2380896',
--Lizzy & Diesel
'2779663',
--William Monk
'1423659',
--Myron Bolitar
'2410366',
--Molly Murphy
'3194524',
--Alex Barnaby
'2236016',
--Lady Julia Grey
'2439059',
--Nero Wolfe
'3151503',
--Cupcake Bakery Mystery
'2750228',
--Jane Austen
'1597748',
--Adam Dalgliesh
'2013721',
--Flower shop
'2281268',
--Bernie Rhodenbarr
'1518318',
--Scrapbooking
'2155004',
--Donut Shop
'2762860',
--cottage tales of beatrix potter
'2247417',
--Harry Bosch
'3735734',
--Shane Scully,
'1972313',
--Kinsey Millhone
'2364264',
--Dave Robicheaux
'2310596',
--Jesse Stone
'1848682',
--Spenser
'1288849',
--Lincoln Rhyme
'1819357',
--87th Precinct
'3079731',
--Elvis Cole
'1473446',
--Inspector Lynley
'2486105',
--Doc Ford
'3621484',
--Stephanie Plum
'2139760',
--Philip Marlowe
'1769413'
)
WHERE b.material_code ='a'
GROUP BY 1,2 
ORDER BY 2
;