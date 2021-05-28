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
'3166664',
'3126439',
'3057240',
'3111937',
'2966718',
'1882130',
'3160265',
'2753366',
'3041373',
'3761898',
'3041373',
'2871299',
'2758333',
'3235132',
'2884875',
'2162927',
'3191058',
'3971089',
'3139541',
'2208975',
'3210686',
'3890903',
'2967195',
'2625975',
'2003767',
'3116805',
'3055934',
'3143700',
'2781223',
'2965485',
'2889457',
'3070015',
'3821680',
'3134096',
'2894463',
'3221900',
'3068243',
'2843589',
'3165700',
'3084559',
'2887723',
'2766203',
'3071554',
'2661070',
'3278831',
'3058177',
'2649158',
'2890531',
'2974781',
'2884884',
'2394776',
'3194449',
'3735907',
'3909210',
'2937845',
'3720069',
'3125995',
'3985450',
'2072824',
'3991967',
'3987005',
'3816691',
'2467889',
'3986994',
'3594136',
'3815585'
)
GROUP BY b.bib_record_id,1,2,b.material_code 
) a
ORDER BY 1
;
