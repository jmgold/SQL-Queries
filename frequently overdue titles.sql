SELECT
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author as field_booklist_entry_author,
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM
sierra_view.fine f
JOIN
sierra_view.record_metadata m
ON
f.item_record_metadata_id = m.id AND m.record_type_code = 'i'
JOIN
sierra_view.item_view i
ON
m.record_num = i.record_num
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
AND SUBSTRING(i.location_code,4,1) NOT IN ('j', 'y')
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id AND b.material_code = 'a'
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
WHERE
f.charge_code = '2'
GROUP BY 1,2,3
ORDER BY COUNT(m.id) desc
LIMIT 50