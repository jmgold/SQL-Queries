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
--chet gecko
'2008746',
--a handful of stars
'3230730',
--a to z
'1719523',
--amelia bedelia
'1934337',
--ballpark mysteries
'2888089',
--Barbie
'2697212',
--cat in the hat
'1542261',
--Clementine
'2426775',
--Diary of a Wimpy Kid
'2483392',
--Dog Man
'3491088',
--dork diaries
'2663186',
--dory fantasmagory
'3192084',
--elephant and piggie
'2477316',
--fantastic mr fox
'3211068',
--fruit ninja
'3763168',
--george brown class clown
'2845824',
--go dog go
'1923245',
--Goosebumps
'1444314',
--green eggs and ham
'1542262',
--Grumpy monkey
'3743314',
--hardy boys
'1122118',
--Harry Potter
'1843295',
--he came with the couch
'2341841',
--Heidi Heckelbeck
'2988411',
--hockey meltdown
'2947418',
--hulk
'3435984',
--i survived
'3763454',
--if these walls could talk, Boston Bruins
'3793626',
--if you give a mouse a cookie
'2172721',
--I've got this
'3769162',
--Judy Moody
'2940456',
--junie b jones
'1444915',
--lego star wars visual dictionary
'3148667',
--little house in the big woods
'2259239',
--love sugar magic
'3682116',
--Lucy and Andy Neanterthal
'3499554',
--lunch lady
'2650740',
--Mac b kid
'3766760',
--magic tree house
'1446456',
--Marley & Me
'2625833',
--Matilda
'1111674',
--Max & Ruby
'2176881',
--Meanwhile
'1833585',
--My Little Pony
'3507057',
--Nancy Drew
'2508793',
--Owl Diaries
'3204739',
--Pete the Cat
'3271232',
--Phoebe and her Unicorn
'3181206',
--Press Start
'3537190',
--rapunzel
'1615938',
--return to the isle of the lost
'3475149',
--sardine in outer space
'2406656',
--scholastic year in sports
'2710988',
--screech owls
'3056083',
--secret coders
'3269194',
--spaghetti and meatballs for all
'1793496',
--spy ski school
'3529338',
--Star Wars
'2565282',
--Stellaluna
'1465686',
--Sunny sweet is so not sorry
'3120497',
--Surfside girls
'3653752',
--Berenstain Bears
'1613183',
--the book with no pictures
'3184069',
--the day the crayons quit
'3063654',
--fairy houses
'2073898',
--Hula-hoopin queen
'3167424',
--Land of stories
'3167829',
--Last kids on Earth
'3400378',
--puppu place
'2850034',
--secret garden
'1792071',
--sinking of the titanic
'2302107',
--spiderwick chronicles
'2241974',
--ultimate book of sharks
'3747146',
--toto
'3662677',
--who is wayne gretzky
'3201338',
--who was clara barton
'3130844',
--who would win
'2971701',
--winnie the pooh
'2036336',
--wish upon a sleepover
'3765825',
--Wonder
'2996974'
)
GROUP BY b.bib_record_id,1,2,b.material_code 
) a
ORDER BY 1
;
