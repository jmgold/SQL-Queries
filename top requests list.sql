--Jeremy Goldstein
--Minuteman Library Network

--top 50 most requested titles in the network

SELECT
'http://find.minlib.net/iii/encore/record/C__R'||id2reckey(h.record_id)   AS "field_booklist_entry_encore_url",
best_title as title,
best_author as field_booklist_entry_author,
(SELECT
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1) AS field_booklist_entry_cover
FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
--limited to books
h.record_id = b.bib_record_id and b.material_code = 'a'
GROUP BY 1,2,3,4
ORDER BY COUNT(h.id) desc
LIMIT 50