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
--George
'3269207',
--A day in the life of Marlon Bundo
'3741008',
--Captain Underpants
'3111041',
--The Hate U Give
'3602957',
--Drama
'3025954',
--Thirteen Reasons Why
'3630705',
--This One Summer
'3151472',
--Skippyjon Jones
'2482616',
--Absolutely True Diary of a parttime Indian
'2665987',
--This day in June
'3179137',
--Two Boys Kissing
'3078887',
--Kite Runner
'2227474',
--Sex is a funny word
'3229677',
--to kill a mockingbird
'1230431',
--and tango makes three
'2327018',
--I am jazz
'3181481',
--Looking for Alaska
'2298182',
--Sex Criminals
'3145833',
--Make something Up
'3211638',
--eleanor & Park
'3044755',
--fifty shades of grey
'2985336',
--beyond magenta
'3132230',
--curious incident of the dog in the night time
'2149849',
--fun home
'2390790',
--Habibi
'2928006',
--Nasreen's secret School
'2724334',
--Persepolis
'2144132',
--The Bluest Eye
'2498231',
--It's perfectly Normal
'1511910',
--Saga
'3031494',
--Perks of being a wallflower
'3017509',
--a stolen Life
'2915963',
--Hunger Games
'3005563',
--A Bad Boy can be good for a girl
'2382854',
--Bless Me Ultima
'1596461',
--Bone
'2277973',
--Scary stories to tell in the dark
'1542820',
--the glass castle
'2371621',
--beloved
'2447309',
--ttyl
'2361987',
--the color of Earth
'2646584',
--my mom's having a baby
'2309903',
--agony of alice
'3125106',
--brave new world
'2918215',
--what my mother doesn't know
'2031969',
--gossip girl
'2077281',
--Prince & Knight
'3734044',
--handmaid's tale
'1889809',
--Harry Potter
'1843295',
--Stamped Racism antiracism and you
'3995833',
--All American Boys
'3278520',
--Speak
'2908783',
--something happened in our town
'3749382',
--of mice and men
'1500886'
)
WHERE b.material_code ='a'
GROUP BY 1,2,3 
ORDER BY 2;
