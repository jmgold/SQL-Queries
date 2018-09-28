SELECT
--link to Encore
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author as field_booklist_entry_author,
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM
sierra_view.bib_record_property b
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN sierra_view.record_metadata m
ON
b.bib_record_id = m.id AND creation_date_gmt > (localtimestamp - interval '30 days')
JOIN
sierra_view.bib_record_order_record_link o
ON
b.bib_record_id = o.bib_record_id
WHERE b.material_code ='a'
AND
NOT EXISTS (SELECT NULL FROM sierra_view.bib_record_item_record_link i WHERE b.bib_record_id = i.bib_record_id)
GROUP BY 1,2,3 
ORDER BY COUNT(o.id) DESC
LIMIT 100;

