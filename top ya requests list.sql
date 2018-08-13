--Jeremy Goldstein
--Minuteman Library Network

--top 50 most requested CD's in the network

SELECT
'http://find.minlib.net/iii/encore/record/C__R'||id2reckey(h.record_id)   AS "URL",
best_title,
best_author,
COUNT(distinct h.id)
FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
--limited to books
h.record_id = b.bib_record_id and b.material_code = 'a'
JOIN
sierra_view.bib_record_item_record_link bi
ON
b.bib_record_id = bi.bib_record_id
JOIN
sierra_view.item_record i
ON
bi.item_record_id = i.id AND SUBSTRING(i.location_code,4,1) = 'y'
GROUP BY 1,2,3
ORDER BY 4 desc
LIMIT 50