--Modified version of code shared by Gem Stone Logan over Sierra mailing list on 4/13/17
--Individual library coding needs to be updated on lines 12, 19, 35, 43, 45

/* Drop the temp table if it already exists */
DROP TABLE IF EXISTS mvhdholds;

/* This is query is run first and create the temp table populating with bibs that have holds over a particular threshold */
CREATE TEMP TABLE mvhdholds AS
SELECT b.id AS "bib_id", 
count(distinct h.id) as "hold_count",
o1.order_locations as "order_locations",
count (distinct CASE WHEN h.pickup_location_code IN ('co2z','conz') then h.id END) AS "local_holds",
CASE
                WHEN count(distinct i.id) IS NULL THEN 0
                ELSE count(distinct i.id)
        END
        AS "item_count",
count(distinct ia.id) as "avail_item_count", 
count(distinct CASE WHEN ia.location_code LIKE 'co%' THEN ia.id END) AS "local_avail_item_count",
max(o1.order_count) AS "order_count",
CASE
                WHEN max(o1.order_copies) IS NULL THEN 0
                ELSE max(o1.order_copies)
        END
        AS "order_copies",
COUNT(DISTINCT h.id) FILTER (WHERE p.ptype_code = '8') AS "local_ptype_holds_count"
FROM sierra_view.bib_record b
LEFT JOIN sierra_view.bib_record_item_record_link bri
on bri.bib_record_id=b.id
LEFT JOIN sierra_view.hold h
ON (h.record_id=b.id OR h.record_id=bri.item_record_id) AND h.status='0'
LEFT JOIN sierra_view.patron_record p
ON
h.patron_record_id = p.id
LEFT JOIN sierra_view.item_record i
ON i.id=bri.item_record_id
LEFT JOIN sierra_view.item_record ia
ON ia.id=bri.item_record_id AND ia.item_status_code in
('-','t','p','!') AND ((ia.location_code NOT LIKE 'co%' AND ia.itype_code_num not in ('5','21','109','133','160','183')) OR ia.location_code LIKE 'co%')
LEFT JOIN (
        SELECT count(o.id) AS "order_count",
        sum(oc.copies) AS "order_copies",        
        string_agg(distinct(oc.location_code), ',') as "order_locations",
        bro.bib_record_id AS "bib_id"
        FROM sierra_view.bib_record_order_record_link BRO
        JOIN sierra_view.order_record o
        ON o.id=bro.order_record_id AND o.accounting_unit_code_num = '8'
        JOIN sierra_view.order_record_cmf oc
        ON oc.order_record_id=o.id AND oc.location_code LIKE 'co%'
        WHERE o.order_status_code = 'o'
        GROUP BY bro.bib_record_id) o1 ON o1.bib_id=b.id
GROUP BY 1, 3
HAVING
count(distinct h.id)>0;


/* This is the report that shows useful things. */
select id2reckey(mv.bib_id)||'a' AS "Record Number",
brp.best_title AS "Title", 
brp.best_author AS "Author", 
brp.publish_year AS "PublicationYear",
bc.name AS "MatType",
mv.item_count as "TotalItemCount", 
max(mv.avail_item_count) as "AvailableItemCount",
mv.hold_count as "TotalHoldCount",
		CASE
                WHEN max(mv.avail_item_count) + max(mv.order_copies)=0 THEN mv.hold_count
                ELSE round(cast((mv.hold_count) as numeric (12, 2))/cast((max(mv.avail_item_count) + max(mv.order_copies)) as numeric(12,2)),2)
        END
        AS "TotalRatio",
max(mv.local_avail_item_count) as "LocalAvailableItemCount",
max(mv.order_copies) as "LocalOrderCopies",
mv.local_holds as "LocalHoldCount",
        CASE
				WHEN max(mv.local_avail_item_count) + max(mv.order_copies)=0 THEN mv.local_holds
                ELSE round(cast((mv.local_holds) as numeric (12, 2))/cast((max(mv.local_avail_item_count) + max(mv.order_copies)) as numeric(12,2)),2)
        END
        AS "LocalRatio",
'http://find.minlib.net/iii/encore/record/C__R'||id2reckey(mv.bib_id)   AS "URL",
mv.order_locations AS "OrderLocations",
mv.local_ptype_holds_count AS "LocalPtypeHoldsCount"
from sierra_view.bib_record_property brp
JOIN mvhdholds mv
ON mv.bib_id=brp.bib_record_id
JOIN
sierra_view.user_defined_bcode2_myuser bc
ON
brp.material_code = bc.code
GROUP BY 1, 2, 3, 4, 5, 6, 8, 12, 14, 15, 16
HAVING mv.local_holds > 0
--(max(mv.item_count) + max(mv.order_copies))=0
--OR max(mv.hold_count)/(max(mv.item_count) + max(mv.order_copies))>=4
ORDER BY 5, 13 desc;