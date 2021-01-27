/*
Jeremy Goldstein & Jenn Del Cegno
Minuteman Library Network
Lazy way to generate curated book list for website
www.minlib.net
*/
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
'3960548',
'3872780',
'2416135',
'2281283',
'2837440',
'3812491',
'3131559',
'3766300',
'3826709',
'2941477',
'3725008',
'1813502',
'3121839',
'3858336',
'3478244',
'3526035',
'3660272',
'3853498',
'3967348',
'3940472',
'2781407',
'3937633',
'3867565',
'3811442',
'3983165',
'3096880',
'3922578',
'1114142',
'3826389',
'3971321',
'3759435',
'3176983',
'3790245',
'3808452',
'3921846',
'3766320',
'3718712',
'3620602',
'2999377',
'3902254',
'3563710',
'2860218',
'3201395',
'3908941',
'3490349',
'3735348',
'3821684',
'3561123'
)
WHERE b.material_code ='a'
GROUP BY 1,2,3 
ORDER BY 2;