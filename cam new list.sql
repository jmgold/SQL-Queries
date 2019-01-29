/*
Jeremy Goldstein
Minuteman Library Network

New Book list for www.minlib.net
*/
SELECT
--link to Encore
i.call_number_norm as call_number,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS url,
b.best_title as title,
b.best_author as author,
ir.icode1 as scat
FROM
sierra_view.bib_record_property b
JOIN sierra_view.bib_record_item_record_link bi
ON
b.bib_record_id = bi.bib_record_id
JOIN sierra_view.item_record_property i
ON
bi.item_record_id = i.item_record_id
JOIN sierra_view.item_record ir
ON
i.item_record_id = ir.id AND ir.location_code LIKE 'cam%'
JOIN sierra_view.record_metadata m
ON
ir.id = m.id AND m.creation_date_gmt > (localtimestamp - interval '1 month')
GROUP BY 2,3,4,1,5
ORDER BY 1
;