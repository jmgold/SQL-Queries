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
--andre the famous harbor seal
'2218878',
--ballpark mysteries
'2888089',
--big dog little dog
'2167942',
--biscuit
'1586271',
--cat in the hat
'1542261',
--danny and the dinosaur
'1465748',
--Diary of a Wimpy Kid
'2483392',
--Dog Man
'3491088',
--dork diaries
'2663186',
--elephant and piggie
'2477316',
--fancy nancy
'3224156',
--flora and the flamingo
'3056226',
--goodnight moon
'1618388',
--green eggs and ham
'1542262',
--lady pancake and sir french toast
'3274960',
--lego friends
'3062136',
--llama llama red pajamas
'2321039',
--mermaid tales
'2988414',
--miracle mud
'3067199',
--Owl Diaries
'3204739',
--paw patrol
'3309591',
--Pete the Cat
'3271232',
--piglet feels small
'2077113',
--pinkalicious
'2413133',
--pokemon
'3629577',
--rapunzel
'1615938',
--strega nona
'1955319',
--ten apples up on top
'1333103',
--captain underpants
'3111041',
--sophie mouse
'3215314',
--the book with no pictures
'3184069',
--the circus ship
'2708790',
--the dinosaur book
'3779875',
--the invisible string
'3017926',
--the magic horse
'1872277',
--ultimate book of sharks
'3747146',
--there was an old lady who swallowed a clover
'2950272',
--thomas the tank engine
'2168286',
--what is the stanley cup
'3810985'
)
GROUP BY b.bib_record_id,1,2,b.material_code 
) a
ORDER BY 1
;
