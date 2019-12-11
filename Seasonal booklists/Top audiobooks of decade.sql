--Jeremy Goldstein
--Minuteman Library Network

--top 50 most requested titles in the network

SELECT
'http://find.minlib.net/iii/encore/search/C__St%3A%28'||replace(b.best_title,' ','%20')||'%29%20f%3A%28s%20%7C%204%20%7C%20z%29__Orightresult__U  
'   AS "field_booklist_entry_encore_url",
b.best_title as title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) AS field_booklist_entry_author,
(SELECT
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(s.content FROM '[0-9X]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1) AS field_booklist_entry_cover
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link bi
ON
b.bib_record_id = bi.bib_record_id
JOIN
sierra_view.item_record i
ON
bi.item_record_id = i.id AND SUBSTRING(i.location_code,4,1) NOT IN ('j')
WHERE
id2reckey(b.bib_record_id) IN(
'b3160478',
'b3215577',
'b2893876',
'b3767414',
'b3179347',
'b3525824',
'b3649285',
'b3716828',
'b3112521',
'b3194160',
'b3526416',
'b3179159',
'b2864796',
'b2975085',
'b3201747',
'b2995590',
'b2607517',
'b3177253',
'b3156481',
'b3188076',
'b3492778',
'b3179349',
'b3187827',
'b2846890',
'b3582771',
'b2238366',
'b3526416',
'b3072139',
'b2879680',
'b3790436',
'b3652362',
'b3521038',
'b3422372',
'b3017450',
'b2937071',
'b3106471',
'b3267978',
'b2952241',
'b3605271',
'b3065561',
'b3508832',
'b3239712',
'b3633209',
'b3199522',
'b3101760',
'b3153230',
'b3199522',
'b2967586',
'b3522565',
'b3750193',
'b3652363',
'b3630771'

)
AND b.material_code IN ('4', 's', 'z')
GROUP BY 1,2,3,4, b.bib_record_id
ORDER BY 
CASE
WHEN id2reckey(b.bib_record_id) = 'b3160478' THEN 1
WHEN id2reckey(b.bib_record_id) = 'b3215577' THEN 2
WHEN id2reckey(b.bib_record_id) = 'b2893876' THEN 3
WHEN id2reckey(b.bib_record_id) = 'b3767414' THEN 4
WHEN id2reckey(b.bib_record_id) = 'b3179347' THEN 5
WHEN id2reckey(b.bib_record_id) = 'b3525824' THEN 6
WHEN id2reckey(b.bib_record_id) = 'b3649285' THEN 7
WHEN id2reckey(b.bib_record_id) = 'b3716828' THEN 8
WHEN id2reckey(b.bib_record_id) = 'b3112521' THEN 9
WHEN id2reckey(b.bib_record_id) = 'b3194160' THEN 10
WHEN id2reckey(b.bib_record_id) = 'b3526416' THEN 11
WHEN id2reckey(b.bib_record_id) = 'b3179159' THEN 12
WHEN id2reckey(b.bib_record_id) = 'b2864796' THEN 13
WHEN id2reckey(b.bib_record_id) = 'b2975085' THEN 14
WHEN id2reckey(b.bib_record_id) = 'b3201747' THEN 15
WHEN id2reckey(b.bib_record_id) = 'b2995590' THEN 16
WHEN id2reckey(b.bib_record_id) = 'b2607517' THEN 17
WHEN id2reckey(b.bib_record_id) = 'b3177253' THEN 18
WHEN id2reckey(b.bib_record_id) = 'b3156481' THEN 19
WHEN id2reckey(b.bib_record_id) = 'b3188076' THEN 20
WHEN id2reckey(b.bib_record_id) = 'b3492778' THEN 21
WHEN id2reckey(b.bib_record_id) = 'b3179349' THEN 22
WHEN id2reckey(b.bib_record_id) = 'b3187827' THEN 23
WHEN id2reckey(b.bib_record_id) = 'b2846890' THEN 24
WHEN id2reckey(b.bib_record_id) = 'b3582771' THEN 25
WHEN id2reckey(b.bib_record_id) = 'b2238366' THEN 26
WHEN id2reckey(b.bib_record_id) = 'b3072139' THEN 27
WHEN id2reckey(b.bib_record_id) = 'b2879680' THEN 28
WHEN id2reckey(b.bib_record_id) = 'b3790436' THEN 29
WHEN id2reckey(b.bib_record_id) = 'b3652362' THEN 30
WHEN id2reckey(b.bib_record_id) = 'b3521038' THEN 31
WHEN id2reckey(b.bib_record_id) = 'b3422372' THEN 32
WHEN id2reckey(b.bib_record_id) = 'b3017450' THEN 33
WHEN id2reckey(b.bib_record_id) = 'b2937071' THEN 34
WHEN id2reckey(b.bib_record_id) = 'b3106471' THEN 35
WHEN id2reckey(b.bib_record_id) = 'b3267978' THEN 36
WHEN id2reckey(b.bib_record_id) = 'b2952241' THEN 37
WHEN id2reckey(b.bib_record_id) = 'b3605271' THEN 38
WHEN id2reckey(b.bib_record_id) = 'b3065561' THEN 39
WHEN id2reckey(b.bib_record_id) = 'b3508832' THEN 40
WHEN id2reckey(b.bib_record_id) = 'b3239712' THEN 41
WHEN id2reckey(b.bib_record_id) = 'b3633209' THEN 42
WHEN id2reckey(b.bib_record_id) = 'b3199522' THEN 43
WHEN id2reckey(b.bib_record_id) = 'b3101760' THEN 44
WHEN id2reckey(b.bib_record_id) = 'b3153230' THEN 45
WHEN id2reckey(b.bib_record_id) = 'b2967586' THEN 46
WHEN id2reckey(b.bib_record_id) = 'b3522565' THEN 47
WHEN id2reckey(b.bib_record_id) = 'b3750193' THEN 48
WHEN id2reckey(b.bib_record_id) = 'b3652363' THEN 49
WHEN id2reckey(b.bib_record_id) = 'b3630771' THEN 50
END
