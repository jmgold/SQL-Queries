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
--Best of Enemies
'3809346',
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
--Artemis Fowl
'1995127',
--Call of the wild
'1579606',
--Death on the Nile
'2917379',
--DUne
'1495014',
--the good shepherd
'3811449',
--Invisible Man
'2125458',
--just mercy
'3180431',
--two kisses for maddy
'2864654',
--voyages of doctor dolittle
'1860039',
--Black Widow
'3410594',
--Eternals
'3858608',
--Little Women
'1687579',
--TV
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
--Chilling Adventures of Sabrina
'3524746',
--Catch 22
'2905888',
--NOS4A2
'3042545',
--Lovecraft Country
'3451427',
--turn of the screw
'2996634',
--Batwoman
'2742916',
--Watchmen
'3198650',
--His Dark Materials
'2964361',
--Expatriates
'3284483',
--wheel of time
'1208377',
--The witcher
'2584155'
)
WHERE b.material_code ='a'
GROUP BY 1,2,3 
ORDER BY RANDOM()
;
