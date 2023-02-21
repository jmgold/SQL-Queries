SELECT
--link to Encore
--'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
'http://find.minlib.net/iii/encore/search/C__St%3A%28'||REPLACE(b.best_title,' ','%20')||'%29%20f%3A%285%20%7C%20u%29'   AS field_booklist_entry_encore_url,
b.best_title as title,
'https://syndetics.com/index.aspx?upc='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM
sierra_view.bib_record_property b
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '024' AND s.tag = 'a'
JOIN sierra_view.record_metadata m
ON
b.bib_record_id = m.id AND creation_date_gmt > (localtimestamp - interval '30 days')
JOIN
sierra_view.bib_record_order_record_link o
ON
b.bib_record_id = o.bib_record_id
WHERE b.material_code IN ('5','u')
AND
NOT EXISTS (SELECT NULL FROM sierra_view.bib_record_item_record_link i WHERE b.bib_record_id = i.bib_record_id)
GROUP BY 1,2 
ORDER BY COUNT(o.id) DESC
LIMIT 50;