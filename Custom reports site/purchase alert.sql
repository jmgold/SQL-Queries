/* 
Jeremy Goldstein
Minuteman Library Network

On Demand Purchase Alert
*/

SELECT
id2reckey(mv.bib_id)||'a' AS "bib_number",
brp.best_title AS "title", 
brp.best_author AS "author", 
brp.publish_year AS "publication_year",
mp.name   AS "mat_type",
mv.item_count AS "total_item_count", 
max(mv.avail_item_count) AS "available_item_count",
mv.hold_count AS "total_hold_count",
CASE
    WHEN max(mv.avail_item_count) + max(mv.order_copies)=0 THEN mv.hold_count
    ELSE round(cast((mv.hold_count) as numeric (12, 2))/CAST((max(mv.avail_item_count) + max(mv.order_copies)) AS numeric(12,2)),2)
    END
AS "network_wide_ratio",
MAX(mv.local_avail_item_count) AS "local_available_item_count",
MAX(mv.order_copies) AS "local_order_copies",
mv.local_holds AS "local_hold_count",
CASE
    WHEN MAX(mv.local_avail_item_count) + max(mv.order_copies)=0 THEN mv.local_holds
    ELSE round(cast((mv.local_holds) AS numeric (12, 2))/CAST((max(mv.local_avail_item_count) + max(mv.order_copies)) AS numeric(12,2)),2)
    END
AS "local_ratio",
'http://find.minlib.net/iii/encore/record/C__R'||id2reckey(mv.bib_id)   AS "url"

FROM sierra_view.bib_record_property brp
JOIN
sierra_view.material_property_myuser mp
ON
brp.material_code = mp.code
JOIN (
SELECT b.id AS "bib_id", 
COUNT(DISTINCT h.id) AS "hold_count",
COUNT(DISTINCT CASE WHEN h.pickup_location_code ~ {{location}} THEN h.id END) AS "local_holds",
CASE
    WHEN count(DISTINCT i.id) IS NULL THEN 0
    ELSE count(DISTINCT i.id)
    END
AS "item_count",
count(DISTINCT ia.id) AS "avail_item_count", 
count(DISTINCT CASE WHEN ia.location_code ~ {{location}} THEN ia.id END) AS "local_avail_item_count",
MAX(o1.order_count) AS "order_count",
CASE
    WHEN max(o1.order_copies) IS NULL THEN 0
    ELSE max(o1.order_copies)
    END
AS "order_copies"

FROM sierra_view.bib_record b
LEFT JOIN 
sierra_view.bib_record_item_record_link bri
ON
bri.bib_record_id=b.id
LEFT JOIN
sierra_view.hold h
ON
(h.record_id=b.id OR h.record_id=bri.item_record_id) AND h.status='0'
LEFT JOIN
sierra_view.item_record i
ON
i.id=bri.item_record_id
LEFT JOIN
sierra_view.item_record ia
ON
ia.id=bri.item_record_id
AND ia.item_status_code NOT IN ('m','n','o','e','z','s','$','a','b','d','g','w')
AND ((ia.location_code !~ {{location}} AND ia.itype_code_num not in ('5','21','109','133','160','183','239','240','241','244','248','249')) OR ia.location_code ~ {{location}})
LEFT JOIN (
        SELECT count(oc.order_record_id) AS "order_count",
        SUM(oc.copies) AS "order_copies",
        bro.bib_record_id AS "bib_id"
        FROM sierra_view.bib_record_order_record_link bro
        JOIN sierra_view.order_record o
        ON o.id=bro.order_record_id
        JOIN sierra_view.order_record_cmf oc
        ON oc.order_record_id=bro.order_record_id AND oc.location_code ~ {{location}}
        WHERE o.order_status_code = 'o'
        GROUP BY bro.bib_record_id
) o1 ON o1.bib_id=b.id

GROUP BY b.id
HAVING
COUNT(DISTINCT h.id)>0) mv
ON mv.bib_id=brp.bib_record_id
WHERE brp.material_code IN ({{mat_type}})
GROUP BY 1, 2, 3, 4, 5, 6, 8, 12, 14
HAVING mv.local_holds >= {{min_local_holds}}
--(max(mv.item_count) + max(mv.order_copies))=0
--OR max(mv.hold_count)/(max(mv.item_count) + max(mv.order_copies))>=4
ORDER BY 5, {{sort}} DESC
LIMIT {{qty}};