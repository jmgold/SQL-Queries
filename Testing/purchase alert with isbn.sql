/*
Jeremy Goldstein
Minuteman Library Network

Supply & demand based purchase recomendations
based in part on code shared by Gem Stone Logan over Sierra mailing list on 4/13/17
*/

/* Drop the temp table if it already exists */
DROP TABLE IF EXISTS mvhdholds;

/* This is query is run first and create the temp table populating with bibs that have holds over a particular threshold */
CREATE TEMP TABLE mvhdholds AS
SELECT 
	b.id AS bib_id, 
	COUNT(DISTINCT h.id) AS hold_count,
	o1.order_locations AS order_locations,
	COUNT(DISTINCT h.id) FILTER(WHERE h.pickup_location_code = 'neez') AS local_holds,
	COUNT(DISTINCT i.id) AS item_count,
	COUNT(DISTINCT ia.id) AS avail_item_count, 
	COUNT(DISTINCT ia.id) FILTER(WHERE ia.location_code LIKE 'nee%') AS local_avail_item_count,
	MAX(o1.order_count) AS order_count,
	CASE
      WHEN MAX(o1.order_copies) IS NULL THEN 0
      ELSE MAX(o1.order_copies)
   END AS order_copies,
	MODE() WITHIN GROUP (ORDER BY SUBSTRING(i.location_code,4,1)) AS age_level

FROM sierra_view.bib_record b
LEFT JOIN sierra_view.bib_record_item_record_link bri
	ON bri.bib_record_id=b.id
LEFT JOIN sierra_view.hold h
	ON (h.record_id=b.id OR h.record_id=bri.item_record_id) AND h.status='0'
LEFT JOIN sierra_view.item_record i
	ON i.id=bri.item_record_id
LEFT JOIN sierra_view.item_record ia
	ON ia.id=bri.item_record_id AND ia.item_status_code IN ('-','t','p','!')
	AND ((ia.location_code NOT LIKE 'nee%' AND ia.itype_code_num NOT IN ('5','21','109','133','160','183','239','240','241','244','248','249')) OR ia.location_code LIKE 'nee%')
LEFT JOIN (
   SELECT COUNT(o.id) AS order_count,
   SUM(oc.copies) AS order_copies,        
   STRING_AGG(DISTINCT(oc.location_code), ',') AS order_locations,
   bro.bib_record_id AS bib_id
        
   FROM sierra_view.bib_record_order_record_link BRO
   JOIN sierra_view.order_record o
      ON o.id=bro.order_record_id AND o.accounting_unit_code_num = '28'
   JOIN sierra_view.order_record_cmf oc
      ON oc.order_record_id=o.id AND oc.location_code LIKE 'nee%'
   
	WHERE o.order_status_code = 'o'
   GROUP BY bro.bib_record_id) o1 
	ON o1.bib_id=b.id
GROUP BY 1, 3

HAVING
COUNT(DISTINCT h.id)>0;

/* This is the report that shows useful things. */
SELECT * FROM (
SELECT
	id2reckey(mv.bib_id)||'a' AS RecordNumber,
	brp.best_title AS Title, 
	brp.best_author AS Author, 
	brp.publish_year AS PublicationYear,
	bc.name AS MatType,
	mv.item_count AS TotalItemCount, 
	MAX(mv.avail_item_count) AS AvailableItemCount,
	mv.hold_count AS TotalHoldCount,
	CASE
      WHEN MAX(mv.avail_item_count) + MAX(mv.order_copies)=0 THEN mv.hold_count
      ELSE ROUND(CAST((mv.hold_count) AS NUMERIC (12, 2))/CAST((MAX(mv.avail_item_count) + MAX(mv.order_copies)) AS NUMERIC(12,2)),2)
   END AS TotalRatio,
	MAX(mv.local_avail_item_count) AS LocalAvailableItemCount,
	MAX(mv.order_copies) AS LocalOrderCopies,
	mv.local_holds AS LocalHoldCount,
   CASE
		WHEN MAX(mv.local_avail_item_count) + MAX(mv.order_copies)=0 THEN mv.local_holds
      ELSE ROUND(CAST((mv.local_holds) AS NUMERIC (12, 2))/CAST((MAX(mv.local_avail_item_count) + MAX(mv.order_copies)) AS NUMERIC(12,2)),2)
   END AS LocalRatio,
	'https://catalog.minlib.net/Record/'||id2reckey(mv.bib_id) AS URL,
	mv.order_locations AS OrderLocations,
	(SELECT
		COALESCE(STRING_AGG(REGEXP_REPLACE(REPLACE(REGEXP_REPLACE(v.field_content,'(\|a|:)','','g'),'|q',' '),'(\|c|\|2|\|d).*?(\||$)',''),', '),'') AS isbns
		
		FROM
		sierra_view.varfield v
		
		WHERE
		brp.bib_record_id = v.record_id AND v.marc_tag IN ('020','024')
	)AS isbns,
	CASE
		WHEN mv.age_level = 'j' THEN 'JUV'
		WHEN mv.age_level = 'y' THEN 'YA'
		WHEN mv.age_level IS NULL THEN 'UNKNOWN'
		ELSE 'ADULT'
	END AS age_level,
	MODE() WITHIN GROUP (ORDER BY CASE
		WHEN d.index_entry ~ '((\yfiction)|(pictorial works)|(tales)|(^\y(?!\w*biography)\w*(comic books strips etc))|(^\y(?!\w*biography)\w*(graphic novels))|(\ydrama)|((?<!hi)stories))(( [a-z]+)?)(( translations into [a-z]+)?)$'
			AND brp.material_code NOT IN ('7','8','b','e','j','k','m','n')
			AND NOT (ml.bib_level_code = 'm'
			AND ml.record_type_code = 'a'
			AND f.p33 IN ('0','e','i','p','s','','c')) THEN 'TRUE'
		WHEN d.index_entry IS NULL THEN 'UNKNOWN'
		ELSE 'FALSE'
	END) AS is_fiction	

FROM sierra_view.bib_record_property brp
JOIN mvhdholds mv
	ON mv.bib_id=brp.bib_record_id
JOIN sierra_view.user_defined_bcode2_myuser bc
	ON brp.material_code = bc.code
LEFT JOIN sierra_view.phrase_entry d
	ON mv.bib_id = d.record_id AND d.index_tag = 'd' AND d.is_permuted = FALSE
LEFT JOIN sierra_view.leader_field ml
	ON mv.bib_id = ml.record_id
LEFT JOIN sierra_view.control_field f
	ON mv.bib_id = f.record_id

GROUP BY 1, 2, 3, 4, 5, 6, 8, 12, 14, 15, 16, 17
HAVING mv.local_holds > 0
--(max(mv.item_count) + max(mv.order_copies))=0
--OR max(mv.hold_count)/(max(mv.item_count) + max(mv.order_copies))>=4
)a

ORDER BY 5, 
	CASE
		WHEN a.LocalHoldCount/3 - a.LocalAvailableItemCount - a.LocalOrderCopies < 0 THEN 0
		ELSE a.LocalHoldCount/3 - a.LocalAvailableItemCount - a.LocalOrderCopies
	END DESC,
	a.LocalRatio DESC