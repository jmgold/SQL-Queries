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
--a crooked kind of perfect
'2521091',
--Because of Winn-Dixie
'1933518',
--Caraval / Legendary
'3723807',
--Charlotte's web
'1388986',
--Cool as Ice / Matt Christopher
'1992882',
--Diary of a Wimpy Kid
'2483392',
--Dog Man
'3491088',
--Harry Potter
'1843295',
--Hero
'3594261',
--Hunger Games
'2600747',
--if these walls could talk, Boston Bruins
'3793626',
--Kicks: Sabotage Season
'3111669',
--little women
'1687579',
--Mike Lupica
'2754105',
--My Weird School
'2248387',
--Nancy Drew
'2508793',
--Naruto
'3005610',
--Never Girls
'3028519',
--Percy Jackson
'2407397',
--Press Here
'2894550',
--Saga of Recluce
'3789961',
--Secret Pizza Party
'3100342',
--Sisters
'3171396',
--TBH
'3685434',
--Goldfish boy
'3606811',
--graveyard book
'2862397',
--Heroes of Olympus
'2836861',
--hitchhiker's guide
'1414729',
--kingdom of fantasy
'2752338',
--Land of stories
'3167829',
--Last kids on Earth
'3400378',
--Miraculous journey of edward Tulane
'2374940',
--one and only ivan
'2950294',
--The Outsiders
'1787939',
--21 balloons
'2012322',
--Danger down the nile
'3176395',
--warrriors
'2136524',
--where's waldo
'2508255',
--Wonder
'2996974'
)
GROUP BY b.bib_record_id,1,2,b.material_code 
) a
ORDER BY 1
;