/*
Jeremy Goldstein
Minuteman Library Network

New Book list for www.minlib.net
*/
SELECT
DISTINCT ON (2)
REPLACE(REPLACE(REPLACE(i.call_number,'|a',''),'[Express] ',''),'[Express View] ','') AS call_number,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS url,
b.best_title AS title,
CASE
WHEN b.best_author ='' THEN b.best_author
ELSE REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1)
END AS author,
ir.icode1 AS scat,
ir.itype_code_num AS itype,
SUBSTRING(ir.location_code,1,3) AS loc

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
i.item_record_id = ir.id AND ir.location_code NOT LIKE 'cam%' AND ir.location_code LIKE 'ca%' AND ir.icode1 NOT IN ('118','219','241','195')
JOIN sierra_view.record_metadata m
ON
ir.id = m.id AND m.creation_date_gmt >= (localtimestamp - interval '1 month')
GROUP BY 7,2,3,4,1,5,6
EXCEPT
SELECT
--link to Encore
REPLACE(REPLACE(REPLACE(i.call_number,'|a',''),'[Express] ',''),'[Express View] ','') AS call_number,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS url,
b.best_title AS title,
CASE
WHEN b.best_author ='' THEN b.best_author
ELSE REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1)
END AS author,
ir.icode1 AS scat,
ir.itype_code_num AS itype,
SUBSTRING(ir.location_code,1,3) AS loc
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
i.item_record_id = ir.id AND ir.location_code NOT LIKE 'cam%' AND ir.location_code LIKE 'ca%' AND ir.icode1 NOT IN ('118','181','183','184','185','195','202','203','204','205','209','219','239','241')
JOIN sierra_view.record_metadata m
ON
ir.id = m.id AND m.creation_date_gmt < (localtimestamp - interval '1 month')
GROUP BY 7,2,3,4,1,5,6
ORDER BY 7,1
;
