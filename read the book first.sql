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
--Black Klansman
'3776398',
--Spiderverse
'3479082',
--The Wife
'3776548',
--can you ever forgive me?
'3802561',
--If Beale street could talk
'3779420',
--Alita Battle Angel
'3712422',
--how to train your dragon
'2228515',
--Captain Marvel
'3528152',
--Nancy Drew and the Hidden Staircase
'1991518',
--The Aftermath
'3077051',
--Shazam
'3237418',
--Pet Sematary
'2059999',
--Best of Enemies
'3809346',
--Hellboy
'3770951',
--the impossible
'3711179',
--After
'3205033',
--Infinity Gauntlet
'3008111',
--a dog's purpose
'3600873',
--sun is also a star
'3539665',
--dark phoenix saga
'2568060',
--new mutants
'1564040',
--Artemis Fowl
'1995127',
--scary stories to tell in the dark
'1542820',
--where'd you go bernadette
'2988900',
--Three Seconds
'2871608',
--It
'1216711',
--Art of racing in the rain
'2555380',
--I Heard you Paint Houses
'3803047',
--the last thing he wanted
'1578547',
--Secrecy World
'3680745',
--the art of racing in the rain
'2585366',
--the woman in the window
'3650356',
--The Kitchen
'3484012',
--The Goldfinch
'3083504',
--The Good Liar
'3454594',
--Motherless Brooklyn
'1882244',
--TV
--The Passage
'2761859',
--Deadly Class
'3237098',
--what in god's name
'2988897',
--Umbrella Academy
'2588224',
--Shrill
'3483079',
--The Perfections
'3188315',
--Good Omens
'2459591',
--Game of thrones
'1581217',
--Chilling Adventures of Sabrina
'3524746',
--Catch 22
'2905888',
--NOS4A2
'3042545',
--Lovecraft Country
'3451427'
)
WHERE b.material_code ='a'
GROUP BY 1,2,3 
ORDER BY RANDOM()
;
