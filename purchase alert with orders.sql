--Modified version of code shared by Gem Stone Logan over Sierra mailing list on 4/13/17

/* Drop the temp table if it already exists */
DROP TABLE IF EXISTS mvhdholds;

/* This is query is run first and create the temp table populating with bibs that have holds over a particular threshold */
CREATE TEMP TABLE mvhdholds AS
SELECT b.id AS "bib_id", 
count(distinct h.id) as "hold_count",
CASE
                WHEN count(distinct i.id) IS NULL THEN 0
                ELSE count(distinct i.id)
        END
        AS "item_count",
count(distinct ia.id) as "avail_item_count", 
max(o1.order_count) AS "order_count",
string_agg(distinct i.location_code, ' ' order by i.location_code desc) as "item_location",
max(o1.order_location) AS "order_location",
CASE
                WHEN max(o1.order_copies) IS NULL THEN 0
                ELSE max(o1.order_copies)
        END
        AS "order_copies"
FROM sierra_view.bib_record b
LEFT JOIN sierra_view.bib_record_item_record_link bri
on bri.bib_record_id=b.id
JOIN sierra_view.hold h
ON (h.record_id=b.id OR h.record_id=bri.item_record_id)
LEFT JOIN sierra_view.item_record i
ON i.id=bri.item_record_id
LEFT JOIN sierra_view.item_record ia
ON ia.id=bri.item_record_id AND ia.item_status_code not in
('m','n','o','e','z','s','$','d','w')
LEFT JOIN (
        SELECT count(o.id) AS "order_count",
        sum(oc.copies) AS "order_copies",
        string_agg(distinct oc.location_code, ' ' order by oc.location_code desc) AS "order_location",
        bro.bib_record_id AS "bib_id"
        FROM sierra_view.bib_record_order_record_link BRO
        JOIN sierra_view.order_record o
        ON o.id=bro.order_record_id AND o.accounting_unit_code_num = '2'
        JOIN sierra_view.order_record_cmf oc
        ON oc.order_record_id=o.id
        WHERE o.order_status_code = 'o'
        GROUP BY bro.bib_record_id) o1 ON o1.bib_id=b.id
WHERE
h.status='0'
AND h.is_frozen='FALSE'
GROUP BY b.id
HAVING
count(distinct h.id)>0;


/* This is the report that shows useful things. */
select 'b'||b.record_num||'a' AS "Record Number",
        CASE
                WHEN string_agg(distinct mv.item_location, ' ' order by mv.item_location desc) IS NULL
                THEN string_agg(distinct mv.order_location, ' ' order by mv.order_location desc)
                ELSE string_agg(distinct mv.item_location, ' ' order by mv.item_location desc)
        END
        AS "Locations",
brp.best_title AS "Title", 
brp.best_author AS "Author", 
brp.material_code AS "MatType",
brp.publish_year AS "PublicationYear",
max(mv.item_count) as "Total item count", 
max(mv.avail_item_count) as "available item count",
max(mv.order_copies) as "Total order copies",
max(mv.hold_count) as "hold count",
        CASE
                WHEN (max(mv.item_count) + max(mv.order_copies))=0 THEN max(mv.hold_count)
                ELSE max(mv.hold_count)/(max(mv.item_count) + max(mv.order_copies))*1.00
        END
        AS "Ratio"
from sierra_view.bib_record_property brp
JOIN mvhdholds mv
ON mv.bib_id=brp.bib_record_id
JOIN sierra_view.bib_view b
ON b.id=brp.bib_record_id
GROUP BY b.record_num, brp.best_title, brp.best_author, brp.material_code
HAVING
(max(mv.item_count) + max(mv.order_copies))=0
OR max(mv.hold_count)/(max(mv.item_count) + max(mv.order_copies))>=4
ORDER BY brp.material_code, "Ratio" desc
