/* 
Jeremy Goldstein
Minuteman Library Network

On Demand Purchase Alert
*/
WITH orders AS (
  SELECT
    COUNT(oc.order_record_id) FILTER(WHERE o.order_status_code = 'o') AS order_count,
    SUM(oc.copies) FILTER (WHERE o.order_status_code = 'o') AS order_copies,
    SUM(oc.copies) FILTER(WHERE o.order_status_code = 'a' AND o.received_date_gmt::DATE >= CURRENT_DATE - INTERVAL '14 days') AS processing_copies,
    bro.bib_record_id AS bib_id
        
	FROM sierra_view.order_record o
	JOIN sierra_view.order_record_cmf oc
	  ON o.id = oc.order_record_id
	JOIN sierra_view.bib_record_order_record_link bro
	  ON o.id=bro.order_record_id
        
	WHERE o.order_status_code IN ('o','a')
	  AND oc.location_code ~ {{location}}	
	  --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
   GROUP BY bro.bib_record_id
),

hold_data AS (
  SELECT 
    b.id AS bib_id, 
	 COUNT(DISTINCT h.id) AS hold_count,
	 COUNT(DISTINCT h.id) FILTER(WHERE h.pickup_location_code ~ {{location}}) AS local_holds,
	 --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
	 COUNT(DISTINCT i.id) AS item_count,
	 COUNT(DISTINCT ia.id) AS avail_item_count, 
	 COUNT(DISTINCT ia.id) FILTER(WHERE ia.location_code ~ {{location}} AND rmia.creation_date_gmt::DATE >= CURRENT_DATE - INTERVAL '14 days') AS in_process_item_count,
	 COUNT(DISTINCT ia.id) FILTER(WHERE ia.location_code ~ {{location}}) AS local_avail_item_count,
	 --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
	 MAX(orders.order_count) AS order_count,
	 CASE
      WHEN MAX(orders.order_copies) IS NULL THEN 0
    	ELSE MAX(orders.order_copies)
    END AS order_copies,
    CASE
      WHEN MAX(orders.processing_copies) IS NULL THEN 0
    	ELSE MAX(orders.processing_copies)
    END AS processing_copies,
	 MODE() WITHIN GROUP (ORDER BY SUBSTRING(i.location_code,4,1)) AS age_level

  FROM sierra_view.bib_record b
  LEFT JOIN sierra_view.bib_record_item_record_link bri
    ON b.id = bri.bib_record_id
  JOIN sierra_view.hold h
    ON b.id = h.record_id
	 OR bri.item_record_id = h.record_id
  LEFT JOIN sierra_view.item_record i
    ON bri.item_record_id = i.id
  --secondary join to only available items
  LEFT JOIN sierra_view.item_record ia
    ON ia.id=bri.item_record_id
	 AND ia.item_status_code IN ('-','t','p','!')
	 AND (
	   (ia.location_code !~ {{location}}
	     AND ia.itype_code_num NOT IN ('5','21','109','133','160','183','239','240','241','244','248','249')) 
	   OR ia.location_code ~ {{location}}
		--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
	   )
  LEFT JOIN sierra_view.record_metadata rmia
    ON ia.id = rmia.id
  LEFT JOIN orders 
    ON orders.bib_id=b.id

  WHERE h.status='0'
		
  GROUP BY b.id
  HAVING COUNT(DISTINCT h.id)>0
)


SELECT
*,
'' AS "PURCHASE ALERT NEW"
FROM(
SELECT
	CASE
		WHEN age_level = 'ADULT' AND is_fiction = 'TRUE' AND mat_type IN ('BOOK', 'LARGE PRINT') THEN 'ADULT FICTION'
		WHEN age_level = 'ADULT' AND is_fiction = 'FALSE' AND mat_type IN ('BOOK', 'LARGE PRINT', 'MUSIC SCORE') THEN 'ADULT NONFIC'
		WHEN age_level = 'JUV' THEN 'JUV'
		WHEN age_level = 'YA' THEN 'YA'
		WHEN mat_type IN ('3-D OBJECT','BLU-RAY','CONSOLE GAME','DVD OR VCD','MUSIC CD','PLAYAWAY AUDIOBOOK','SPOKEN CD') THEN 'ADULT AV'
		WHEN age_level = 'ADULT' AND is_fiction = 'UNKNOWN' THEN 'ADULT UNKNOWN'
		ELSE 'OTHER/UNKNOWN'
	END AS collection,
	mat_type,
	bib_number,
	title,
	author,
	publication_year,
	total_item_count,
	total_available_item_count,
	total_hold_count,
	total_demand_ratio,
	local_item_count,
	local_available_item_count,
	local_order_copies,
	local_copies_in_process,
	local_hold_count,
	local_demand_ratio,
	CASE
		WHEN CAST(local_hold_count AS NUMERIC(12, 2)) / CAST({{hold_threshold}} AS NUMERIC(12, 2)) - local_available_item_count - local_order_copies - local_copies_in_process < 0 THEN 0
		ELSE ROUND(CAST(local_hold_count AS NUMERIC(12, 2)) / CAST({{hold_threshold}} AS NUMERIC(12, 2)) - local_available_item_count - local_order_copies - local_copies_in_process,1)
	END AS suggested_purchase_qty,
	url,
	isbn_upc,
	is_fiction
	
FROM (
	SELECT
		id2reckey(hd.bib_id)||'a' AS bib_number,
		brp.best_title AS title, 
		brp.best_author AS author, 
		brp.publish_year AS publication_year,
		mp.name AS mat_type,
		hd.item_count AS total_item_count, 
		MAX(hd.avail_item_count) AS total_available_item_count,
		hd.hold_count AS total_hold_count,
		CASE
  		  	WHEN MAX(hd.avail_item_count) + MAX(hd.order_copies) + 
				(
				CASE
					WHEN MAX(hd.processing_copies) > 0 AND MAX(hd.in_process_item_count) < MAX(hd.processing_copies) THEN MAX(hd.processing_copies) - MAX(hd.in_process_item_count)
					ELSE 0
				END
				)
			= 0 THEN hd.hold_count
  		  	ELSE ROUND(CAST((hd.hold_count) AS NUMERIC(12, 2))/CAST((MAX(hd.avail_item_count) + MAX(hd.order_copies) + 
				(
				CASE
					WHEN MAX(hd.processing_copies) > 0 AND MAX(hd.in_process_item_count) < MAX(hd.processing_copies) THEN MAX(hd.processing_copies) - MAX(hd.in_process_item_count)
					ELSE 0
				END
				)
			) AS NUMERIC(12,2)),2)
  		END AS total_demand_ratio,
		COUNT(DISTINCT ir.id) FILTER(WHERE ir.location_code ~ {{location}}) AS local_item_count,
		MAX(hd.local_avail_item_count) AS local_available_item_count,
		MAX(hd.order_copies) AS local_order_copies,
		CASE
			WHEN MAX(hd.processing_copies) > 0 AND MAX(hd.in_process_item_count) < MAX(hd.processing_copies) THEN MAX(hd.processing_copies) - MAX(hd.in_process_item_count)
			ELSE 0
		END AS local_copies_in_process,
		hd.local_holds AS local_hold_count,
		CASE
    		WHEN MAX(hd.local_avail_item_count) + MAX(hd.order_copies) + 
				(
				CASE
					WHEN MAX(hd.processing_copies) > 0 AND MAX(hd.in_process_item_count) < MAX(hd.processing_copies) THEN MAX(hd.processing_copies) - MAX(hd.in_process_item_count)
					ELSE 0
				END
				)
			= 0 THEN hd.local_holds
    		ELSE ROUND(CAST((hd.local_holds) AS NUMERIC(12, 2))/CAST((MAX(hd.local_avail_item_count) + MAX(hd.order_copies) +
				(
				CASE
					WHEN MAX(hd.processing_copies) > 0 AND MAX(hd.in_process_item_count) < MAX(hd.processing_copies) THEN MAX(hd.processing_copies) - MAX(hd.in_process_item_count)
					ELSE 0
				END
				)
			) AS NUMERIC(12,2)),2)
   	END AS local_demand_ratio,
		'https://catalog.minlib.net/Record/'||id2reckey(hd.bib_id) AS url,
		(SELECT
			COALESCE(STRING_AGG(REGEXP_REPLACE(REPLACE(REGEXP_REPLACE(v.field_content,'(\|a|:)','','g'),'|q',' '),'(\|c|\|2|\|d).*?(\||$)',''),', '),'') AS isbns
		
			FROM sierra_view.varfield v
		
			WHERE brp.bib_record_id = v.record_id AND v.marc_tag IN ('020','024')
		)AS isbn_upc,
		MODE() WITHIN GROUP (ORDER BY CASE
			WHEN d.index_entry ~ '((\yfiction)|(pictorial works)|(tales)|(^\y(?!\w*biography)\w*(comic books strips etc))|(^\y(?!\w*biography)\w*(graphic novels))|(\ydrama)|((?<!hi)stories))(( [a-z]+)?)(( translations into [a-z]+)?)$'
				AND brp.material_code NOT IN ('7','8','b','e','j','k','m','n')
				AND NOT (ml.bib_level_code = 'm'
				AND ml.record_type_code = 'a'
				AND f.p33 IN ('0','e','i','p','s','','c')) THEN 'TRUE'
			WHEN d.index_entry IS NULL THEN 'UNKNOWN'
			ELSE 'FALSE'
		END) AS is_fiction,
		CASE
			WHEN hd.age_level = 'j' THEN 'JUV'
			WHEN hd.age_level = 'y' THEN 'YA'
			WHEN hd.age_level IS NULL THEN 'UNKNOWN'
			ELSE 'ADULT'
		END AS age_level

	FROM sierra_view.bib_record_property brp
	JOIN hold_data hd
		ON brp.bib_record_id = hd.bib_id
	LEFT JOIN sierra_view.bib_record_item_record_link bri
		ON brp.bib_record_id=bri.bib_record_id
	LEFT JOIN sierra_view.item_record ir
		ON bri.item_record_id = ir.id
	JOIN sierra_view.material_property_myuser mp
		ON brp.material_code = mp.code
	LEFT JOIN sierra_view.phrase_entry d
		ON hd.bib_id = d.record_id AND d.index_tag = 'd' AND d.is_permuted = FALSE
	LEFT JOIN sierra_view.leader_field ml
		ON hd.bib_id = ml.record_id
	LEFT JOIN sierra_view.control_field f
		ON hd.bib_id = f.record_id
	
	GROUP BY brp.bib_record_id,1, 2, 3, 4, 5, 6, 8, 14, 16, 19
	HAVING hd.local_holds >= {{min_local_holds}}

	)inner_query

ORDER BY
	1,2, 
	CASE
		WHEN CAST(local_hold_count AS NUMERIC(12, 2)) / CAST({{hold_threshold}} AS NUMERIC(12, 2))  - local_available_item_count - local_order_copies - local_copies_in_process < 0 THEN 0
		ELSE ROUND(CAST(local_hold_count AS NUMERIC(12, 2)) / CAST({{hold_threshold}} AS NUMERIC(12, 2)) - local_available_item_count - local_order_copies - local_copies_in_process,1)
	END DESC
)a