/*
Jeremy Goldstein
Minuteman Library Network

Produces list of the 50 titles that most frequently incur overdue fines with a copy owned by a location
*/

SELECT
--Link to Encore
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
SPLIT_PART(b.best_author,', ',1)||', '||REPLACE(TRANSLATE(SPLIT_PART(b.best_author,', ',2),'.',','),',','') AS field_booklist_entry_author,
--Link to cover from Syndetics
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover

FROM
sierra_view.bib_record_property b
--Pull ISBN for cover image
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id --AND i.location_code ~ '^brk'
JOIN
sierra_view.fine f
ON
--Limit to overdue charge_code
i.id = f.item_record_metadata_id AND f.charge_code = '2'
JOIN
sierra_view.bib_record_location bl
ON
b.bib_record_id = bl.bib_record_id AND bl.location_code ~ '^act'
WHERE
--limit to book
b.material_code IN ('a')
GROUP BY 1,2,3
ORDER BY COUNT(f.id) desc
LIMIT 50
