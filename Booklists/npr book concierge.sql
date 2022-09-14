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
'4104918',
'4109220',
'4118919',
'4120837',
'3937592',
'4021105',
'4021337',
'4026176',
'4028144',
'4028491',
'4028493',
'4030186',
'4031140',
'4031196',
'4031249',
'4031242',
'4031382',
'4031797',
'4031795',
'4031778',
'4033848',
'4036684',
'4036704',
'4033847',
'4033849',
'4033846',
'4034036',
'4034876',
'4035524',
'4036070',
'4036854',
'4036835',
'4037096',
'4037572',
'4037646',
'4037658',
'4038043',
'4038035',
'4038039',
'3990516',
'4039538',
'4041670',
'4042254',
'4042259',
'4042258',
'4042275',
'4042278',
'4042361',
'4042437',
'4042497',
'4043659',
'4041851',
'4041841',
'4041848',
'4042431',
'4042460',
'4042467',
'4042483',
'4043163',
'4044664',
'4044665',
'4044672',
'4045465',
'4045510',
'4045629',
'4045703',
'4045644',
'4045700',
'4047866',
'4047839',
'4047885',
'4047881',
'4048485',
'4049324',
'4050453',
'4050254',
'4047836',
'4047845',
'4047931',
'4048446',
'4049326',
'4049330',
'4049334',
'4050177',
'4050293',
'4050308',
'4051044',
'4051135',
'4051141',
'4051132',
'4051554',
'4053429',
'4053450',
'4053426',
'4053438',
'4053464',
'4053467',
'4053496',
'4053544',
'4053810',
'4054017',
'4055019',
'4055011',
'4055063',
'4055244',
'4055512',
'4055480',
'4055842',
'4056188',
'4056222',
'4056186',
'4056303',
'4056340',
'4057970',
'4056182',
'4056392',
'4056791',
'4056785',
'4057363',
'4060893',
'4061109',
'4061231',
'4061258',
'4061357',
'4062088',
'4062489',
'4062461',
'4062550',
'4062597',
'4062718',
'4064298',
'4066319',
'4066527',
'4062866',
'4063957',
'4064088',
'4064231',
'4065562',
'4065637',
'4066993',
'4069083',
'4069063',
'4069082',
'4069154',
'4069479',
'4069605',
'4069730',
'4069754',
'4071727',
'4071978',
'4073991',
'4074418',
'4075998',
'4076004',
'4077727',
'4077726',
'4042588',
'4079848',
'4085457',
'4086242',
'4087220'

)
GROUP BY b.bib_record_id,1,2,b.material_code 
) a
ORDER BY RANDOM()
LIMIT 50;
;