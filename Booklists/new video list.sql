SELECT
--link to Encore
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author as field_booklist_entry_author,
'https://syndetics.com/index.aspx?upc='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM
sierra_view.bib_record_property b
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '024' AND s.tag = 'a'
JOIN sierra_view.bib_record_item_record_link bi
ON
b.bib_record_id = bi.bib_record_id
JOIN sierra_view.record_metadata m
ON
bi.item_record_id = m.id AND m.creation_date_gmt > (localtimestamp - interval '7 days')
JOIN sierra_view.bib_record br
ON
b.bib_record_id = br.id AND (br.cataloging_date_gmt > (localtimestamp - interval '7 days') OR br.cataloging_date_gmt IS NULL)
WHERE b.material_code IN ('5','u')
GROUP BY 1,2,3 
ORDER BY COUNT(bi.bib_record_id) desc
LIMIT 100;