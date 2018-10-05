--Jeremy Goldstein
--Minuteman Library Network

--top 50 trending titles in the network

SELECT
'http://find.minlib.net/iii/encore/record/C__R'||id2reckey(h.record_id)   AS "field_booklist_entry_encore_url",
best_title as title,
best_author as field_booklist_entry_author,
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
--limited to books
h.record_id = b.bib_record_id and b.material_code = 'a'
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
WHERE
h.placed_gmt > (localtimestamp - interval '2 days')
GROUP BY 1,2,3
ORDER BY 4 desc
LIMIT 50