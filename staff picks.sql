SELECT *
FROM(
SELECT
--link to Encore, removed in favor of default keyword search on title
--'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title as title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) as field_booklist_entry_author,
CASE
WHEN b.material_code = 'a'
THEN (SELECT
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1)
WHEN b.material_code != 'a'
THEN (SELECT
'https://syndetics.com/index.aspx?upc='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '024' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1)
END AS field_booklist_entry_cover

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
--20200205 Jeremy Goldstein
--vacationland
'3652176',
--The Deep
'3825839',
--how to invent everything
'3769049',
--Snagglepuss Chronicles
'3783294',
--Spinning Silver
'3755652',
--Die
'3814206',
--Space Opera
'3725134',
--Gideon the Ninth
'3838330',
--20200205 Jonathan Reinhart
'3835519',
'3603746',
'3488131',
'3789976',
'3789978',
'2544412',
'1946196',
'2574931',
'3816140',
'2406924',
'3017509',
'3767818',
'2382690',
'2638413',
'2444431',
'2782998',
'2551355',
'1243202',
'2729795',
'1505152',
'3003218',
'1367236',
'1090823',
--20200205 Dev Singer
'3853104',
'3757176',
'3833060',
--20200205 Anna Sarneso
'3808188',
--20200205 Kevin O'Kelly
'3830926',
--20200205 Sophie Forrester
'3823360',
'1858821',
'3738982',
'3829717',
'3845969',
'1075807',
'3831641',
'2963695',
'2498145',
'2651560',
'1293974',
'2651071',
'2622125',
'1486213',
'2903719',
--20200205 Refina Lewis
'3818647',
'3788540',
'3528407',
'3634811',
--20200205 Allison Smith
'3142168',
'3792142',
'3859897',
'3830915',
'3814086',
'3818244',
'3823360',
--20200205 Karen Donaghey
'3675994',
'2928502',
'1141593',
--20200205 Mary Carter
'3777938',
'2968267',
'2761839',
'3110294',
'3163998',
'3611335',
'3272328',
'2746659',
'3107629',
'3818580',
'3801281',
'3813008',
'3113502',
'3621400',
'3566353',
'3047845',
'3718164',
'3002599',
'3223099',
'3755652',
'3095283',
'2667099',
'2133780',
'3167440',
'3209365',
'3021685',
'3066044',
'2908140',
'3186319',
'1532877',
'1525617',
'2597289',
'3010511',
'3157047',
'2856180',
'2730511',
'2522001',
'3020336',
'2467715',
'2305729',
--20200205 Mary Grahame Hunter
'3808188',
'3526096',
'3743047',
'3814192',
'3864086',
'3520596',
--20200205 Jillian Holmberg
'2947062',
'2213893',
'3226168',
'3102202',
'1503791',
'3853779',
'3718164',
'3763603',
--20200205 Lucia Dolan
'3853228',
--20200205 Meghan Bouffard
'3815724',
'2955063',
'2448597',
'3539665',
--20200205 MJ Wright
'2987467',
'3856881',
'3802434',
'3681790',
'3781070',
'3812322',
'3273254',
--20200205 Brita Zitin
'3045943',
'2502640',
'2392981',
'1994618',
'3163329',
'2643189',
'3245698',
--20200205 Robin Demas
'2752115',
--20200205 Jennifer Keen
'3010518',
'3216412',
'3853080',
'2903719',
'2105282',
--20200205 Jess S
'2392257',
'1581178'
)
GROUP BY b.bib_record_id,1,2,b.material_code 
) a
ORDER BY RANDOM()
LIMIT 50;
;