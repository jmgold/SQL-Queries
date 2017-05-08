--Modified version of code shared by Gem Stone Logan over Sierra mailing list on 4/13/17
--Individual library coding needs to be updated on lines 11, 18, 41, 43

/* Drop the temp table if it already exists */
DROP TABLE IF EXISTS mvhdholds;

/* This is query is run first and create the temp table populating with bibs that have holds over a particular threshold */
CREATE TEMP TABLE mvhdholds AS
SELECT b.id AS "bib_id", 
count(distinct h.id) as "hold_count",
count (distinct CASE WHEN h.pickup_location_code = 'arlz' then h.id END) AS "local_holds",
CASE
                WHEN count(distinct i.id) IS NULL THEN 0
                ELSE count(distinct i.id)
        END
        AS "item_count",
count(distinct ia.id) as "avail_item_count", 
count(distinct CASE WHEN ia.location_code LIKE 'arl%' THEN ia.id END) AS "local_avail_item_count",
max(o1.order_count) AS "order_count",
CASE
                WHEN max(o1.order_copies) IS NULL THEN 0
                ELSE max(o1.order_copies)
        END
        AS "order_copies"
FROM sierra_view.bib_record b
LEFT JOIN sierra_view.bib_record_item_record_link bri
on bri.bib_record_id=b.id
LEFT JOIN sierra_view.hold h
ON (h.record_id=b.id OR h.record_id=bri.item_record_id) AND h.status='0'
LEFT JOIN sierra_view.item_record i
ON i.id=bri.item_record_id
LEFT JOIN sierra_view.item_record ia
ON ia.id=bri.item_record_id AND ia.item_status_code not in
('m','n','o','e','z','s','$','d','w')
LEFT JOIN (
        SELECT count(o.id) AS "order_count",
        sum(oc.copies) AS "order_copies",
        bro.bib_record_id AS "bib_id"
        FROM sierra_view.bib_record_order_record_link BRO
        JOIN sierra_view.order_record o
        ON o.id=bro.order_record_id AND o.accounting_unit_code_num = '2'
        JOIN sierra_view.order_record_cmf oc
        ON oc.order_record_id=o.id AND oc.location_code LIKE 'arl%'
        WHERE o.order_status_code = 'o'
        GROUP BY bro.bib_record_id) o1 ON o1.bib_id=b.id
GROUP BY b.id
HAVING
count(distinct h.id)>0;


/* This is the report that shows useful things. */
select id2reckey(mv.bib_id)||'a' AS "Record Number",
brp.best_title AS "Title", 
brp.best_author AS "Author", 
brp.publish_year AS "PublicationYear",
CASE
    WHEN brp.material_code = '2' THEN 'Large Print'
    WHEN brp.material_code = '3' THEN 'Periodical'
    WHEN brp.material_code = '4' THEN 'Spoken CD'
    WHEN brp.material_code = '5' THEN 'DVD'
    WHEN brp.material_code = '6' THEN 'Film/Strip'
    WHEN brp.material_code = '7' THEN 'Music Cassette'
    WHEN brp.material_code = '8' THEN 'LP'
    WHEN brp.material_code = '9' THEN 'Juv Book + CD'
    WHEN brp.material_code = 'a' THEN 'Book'
    WHEN brp.material_code = 'b' THEN 'Archival Material'
    WHEN brp.material_code = 'c' THEN 'Music Score'
    WHEN brp.material_code = 'e' THEN 'Map'
    WHEN brp.material_code = 'g' THEN 'VHS'
    WHEN brp.material_code = 'h' THEN 'Downloadable eBook'
    WHEN brp.material_code = 'i' THEN 'Spoken Cassette'
    WHEN brp.material_code = 'j' THEN 'Music CD'
    WHEN brp.material_code = 'k' THEN '2D Visual Material'
    WHEN brp.material_code = 'l' THEN 'Downloadable Video'
    WHEN brp.material_code = 'm' THEN 'Software'
    WHEN brp.material_code = 'n' THEN 'Console Game'
    WHEN brp.material_code = 'o' THEN 'Kit'
    WHEN brp.material_code = 'p' THEN 'Mixed Material'
    WHEN brp.material_code = 'q' THEN 'Equipment'
    WHEN brp.material_code = 'r' THEN '3D Object'
    WHEN brp.material_code = 's' THEN 'Downloadable Audiobook'
    WHEN brp.material_code = 't' THEN 'Manuscript'
    WHEN brp.material_code = 'u' THEN 'Blu-ray'
    WHEN brp.material_code = 'v' THEN 'eReader/Tablet'
    WHEN brp.material_code = 'w' THEN 'Downloadable Music'
    WHEN brp.material_code = 'x' THEN 'Playaway Video'
    WHEN brp.material_code = 'y' THEN 'Online'
    WHEN brp.material_code = 'z' THEN 'Playaway Audio'
    ELSE 'unexpected code '||brp.material_code
END     AS "MatType",
mv.item_count as "TotalItemCount", 
max(mv.avail_item_count) as "AvailableItemCount",
max(mv.local_avail_item_count) as "LocalAvailableItemCount",
max(mv.order_copies) as "LocalOrderCopies",
mv.hold_count as "TotalHoldCount",
mv.local_holds as "LocalHoldCount",
        CASE
                WHEN max(mv.avail_item_count) + max(mv.order_copies)=0 THEN mv.hold_count
                ELSE mv.hold_count/(max(mv.avail_item_count) + max(mv.order_copies))*1.00
        END
        AS "Ratio",
'http://find.minlib.net/iii/encore/record/C__R'||id2reckey(mv.bib_id)   AS "URL"
from sierra_view.bib_record_property brp
JOIN mvhdholds mv
ON mv.bib_id=brp.bib_record_id
GROUP BY 1, 2, 3, 4, 5, 6, 10, 11, 13
HAVING mv.local_holds > 0
-- Optional filter to set supply and demand ratio limit
-- AND (max(mv.item_count) + max(mv.order_copies))=0
--OR max(mv.hold_count)/(max(mv.item_count) + max(mv.order_copies))>=4
ORDER BY 5, 12 desc;

