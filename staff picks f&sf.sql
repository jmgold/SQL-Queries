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
END AS field_booklist_entry_cover,
v.record_num

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
--The Deep
'3825839',
--Spinning Silver
'3755652',
--Space Opera
'3725134',
--Gideon the Ninth
'3838330',
--bayern agenda
'3822208',
--her body and other parties
'3653799',
--Excellence
'3859399',
--20200205 Dev Singer
'3853104',
--20200205 Sophie Forrester
'2622125',
'2903719',
--20200205 Allison Smith
'3792142',
--20200205 Karen Donaghey
'3675994',
'1141593',
--20200205 Mary Carter
'3777938',
'2968267',
'3110294',
'3163998',
'3611335',
'3272328',
'2746659',
'3107629',
'3113502',
'3621400',
'3047845',
'3223099',
'3755652',
'3095283',
'2133780',
'3010511',
'2856180',
'3020336',
--20200205 Jillian Holmberg
'3102202',
'3718164',
--20200205 Meghan Bouffard
'2955063',
'3539665',
--20200205 Jennifer Keen
'3010518',
'2903719',
'2105282',
--20200205 Jess S
'1581178',
--20200205 Alicia Fernandez
'3860008',
'3735121',
--20200205 Mariśca Mozeleski
'3825771',
'3829725',
'3869137',
'3838394',
'3633283',
'3800716',
--20200205 Jessica Steytler
'3526096',
'3282745',
'3237608',
'3637136',
'3800631',
--20200205 Sam Sednek
'3868364',
--20200205 Quincy Knapp
'3143812',
'1909015',
'3503527',
'3755652',
--20200205 Peter Hansen II
'2409171',
'3212431',
'3079576',
'3011713',
--20200205 Jenny Arch
'3853121',
'3655837',
'3651672',
'2603916',
'3170655',
'3852145',
'3656838',
'3659252',
'2927832',
'3229184',
'3195657',
'3804175',
'3788098',
'3826374',
'3802377',
--20200206 Andrew Loof
'3464408',
'3141569',
'2135225',
'2713470',
--20200206 Stefanie Claydon
'1593162',
'1996844',
'2130806',
'3530777',
'3650498',
'3808256',
'3563894',
'1979269',
'3164123',
'2902522',
'3853402',
'3838394',
'3526096',
'3654507',
'3767055',
'3223099',
'3742476',
'2610365',
'2470540',
'2003332',
--20200208 Lily Weitzman
'3725134',
'3838395',
'3272328',
'3650288',
'3650323',
'3275884',
'3656837',
'3633283',
'3718094',
'3815548',
'3071093',
'3653799',
--20200209 Lucia Dolan
'3633283',
--20200210 Sara Belisle
'3540067'
--20200212 Jeremy Robichaud
'3650415',
'2897852',
'3585668',
'3501864',
'3212204',
--20200626 Jenny Arch
'3770185',
'3145781',
'3656838',
'1477070',
'3875892',
'2925942',
'3650498',
'3807510',
'3788098',
'3655837',
'3229184',
'3882566',
'3838395',
'3852145'
)
GROUP BY b.bib_record_id,1,2,b.material_code,4 
) a
ORDER BY RANDOM()
--LIMIT 50
;