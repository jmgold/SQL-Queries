SELECT
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS "url",
B.best_title as title,
B.best_author as author,
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS cover
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.circ_trans c
ON
b.bib_record_id = c.bib_record_id AND c.op_code = 'i' AND c.transaction_gmt > (localtimestamp - interval '1 day')
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
AND
i.is_available_at_library = 'TRUE'
AND i.item_status_code NOT IN ('m', 'n', 'z', 't', 'o', '$', '!', 'w', 'd', 'p', 'r', 'e', 'j', 'u', 'q', 'x', 'y', 'v')
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
GROUP BY 1,2,3
LIMIT 50

