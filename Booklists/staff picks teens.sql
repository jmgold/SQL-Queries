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
--Die
'3814206',
--good enough
'3811315',
--20200205 Dev Singer
'3757176',
--20200205 Jillian Holmberg
'2213893',
'3226168',
'3102202',
'3763603',
--20200205 Meghan Bouffard
'3815724',
'2955063',
'3539665',
--20200205 Jennifer Keen
'3010518',
'3216412',
'2105282',
--20200205 Alicia Fernandez
'3860008',
'3734974',
'3735121',
--20200205 Mariśca Mozeleski
'3825771',
'3829725',
'3864614',
'3869137',
'3858482',
'3748410',
'3800716',
'3831661',
--20200205 Sam Sednek
'3868364',
--20200205 Royce McGrath
'3445745',
'3804935',
--20200205 Julie Kellndorfer
'3825771',
'3808188',
'3659250',
'3775527',
'3817272',
'3790582',
'3853855',
'3538318',
'3661171',
'3135210',
'3142677',
'3825862',
--20200205 Peter Hansen II
'2409171',
'3212431',
'2750217',
'3079576',
'3011713',
--20200205 Rachel Simon
'3859133',
--20200205 Ariel Flowers
'2199975',
--20200206 Olivia Durant
'3651672',
--20200206 Ellen Jacobs
'3171397',
'3659356',
'3763723',
'3874244',
'3524701',
'2776793',
'3023281',
'2576963',
'2394207',
'2901477',
'1969580',
'1973173',
--20200208 Yi Bin Liang
'2944357',
'3779641',
'3659211',
--20200208 Lily Weitzman
'3010511',
'3713831',
'3200228',
'3716774',
'3044763',
'3276861',
'3213370',
'3657334',
'3649157',
--20210209 Karen Stevens
'3725546',
'3815636',
'3982970'
)
GROUP BY b.bib_record_id,1,2,b.material_code 
) a
ORDER BY RANDOM()
LIMIT 50;
;
