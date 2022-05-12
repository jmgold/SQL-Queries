/*
Jeremy Goldstein & Jenn Del Cegno
Minuteman Library Network
Lazy way to generate curated book list for website
www.minlib.net
*/
SELECT *
FROM(
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
'3940609',
'2863621',
'2846277',
'2881845',
'3457209',
'3141928',
'2986544',
'3715068',
'3478787',
'2846644',
'3718571',
'3720516',
'3180428',
'2764881',
'2979825',
'1774490',
'1903694',
'2802043',
'2759776',
'3448208',
'3755384',
'3950502',
'3814354',
'2704007',
'2945405',
'3172695',
'2912570',
'3851805',
'3611848',
'3457306',
'2166578',
'116915',
'3933378',
'2945245',
'3908818',
'3963210',
'3473097',
'3086437',
'3854347',
'2754583',
'3622846',
'3890786',
'2988806',
'3154587',
'2672506',
'3892317',
'3600866',
'3028814',
'3848540',
'3616364',
'3835662',
'3878962',
'3781793',
'3068838',
'3936954',
'3182519',
'2910087',
'101848',
'2101395',
'2934528',
'2775948',
'3650236',
'3099687',
'2088283',
'2937621',
'3854354',
'3873455',
'3789947',
'3722630',
'3862395',
'2958269',
'1870118',
'3439132',
'2889544',
'3218840',
'3146082',
'3984788',
'3765487',
'3855680',
'125957',
'3858340',
'2524800',
'2446601',
'2575521',
'3129041',
'3047681',
'3977119',
'3903380',
'3713366',
'3678644',
'3211699',
'2725863',
'3430669',
'2853498',
'2904468',
'3469763',
'2390337',
'3622050',
'1030716',
'2249662',
'2747039',
'2538757',
'2266701',
'3802339',
'3908165',
'2880604',
'3891885',
'3844198',
'3826711',
'2475008',
'2753736',
'3978054',
'2345711',
'1898464',
'3753717',
'2187194',
'1144623',
'2277218'
)
WHERE b.material_code ='a'
GROUP BY 1,2,3 ) a
ORDER BY RANDOM()
LIMIT 50;