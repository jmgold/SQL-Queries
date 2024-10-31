/*
Jeremy Goldstein
Minuteman Library Network

Capture daily counts of paged items for Wayland
Based on Wayland items just placed in transit or on the holdshelf to fulfill a hold
*/

WITH transit AS (
	SELECT
		i.id AS id,
		i.location_code,
		SUBSTRING(SPLIT_PART(SPLIT_PART(v.field_content,'from ',2),' to',1)FROM 1 FOR 3) AS origin_loc,
		SUBSTRING(SPLIT_PART(v.field_content,'to ',2) FROM 1 FOR 3) AS destination_loc
	
	FROM sierra_view.item_record i
	JOIN sierra_view.varfield v
		ON i.id = v.record_id AND v.varfield_type_code = 'm' AND v.field_content LIKE '%IN TRANSIT%'
	JOIN sierra_view.hold h
		ON i.id = h.record_id AND h.status = 't'

WHERE
	i.item_status_code = 't'
	AND (SUBSTRING(SPLIT_PART(SPLIT_PART(v.field_content,'from ',2),' to',1)FROM 1 FOR 3) = 'wyl'  OR SUBSTRING(SPLIT_PART(v.field_content,'to ',2) FROM 1 FOR 3) = 'wyl')
)

SELECT
	TO_CHAR(CURRENT_DATE,'YYYY-MM-DD') AS "date",
	l.name AS library,
	COUNT(DISTINCT t.id) FILTER (WHERE t.origin_loc = l.code AND TO_TIMESTAMP(SPLIT_PART(v.field_content,': ',1),'DY MON DD YYYY HH:MIAM')::DATE != i.last_checkin_gmt::DATE) AS transit_from,
	COUNT(DISTINCT t.id) FILTER (WHERE t.destination_loc = l.code AND t.location_code ~ '^wyl') AS transit_to,
	CASE
		WHEN l.name != 'WAYLAND' THEN 0
		ELSE(
			SELECT 
			COUNT(h.id)
			FROM sierra_view.hold h
			JOIN sierra_view.item_record i
				ON h.record_id = i.id AND i.location_code ~ '^wyl'
				AND SUBSTRING(h.pickup_location_code,1,3) = 'wyl'
				AND h.status IN ('b','i')
				AND h.on_holdshelf_gmt::DATE = CURRENT_DATE
				--exclude items that were checked in instead of being paged
				AND abs(EXTRACT(EPOCH FROM (i.last_checkin_gmt - h.on_holdshelf_gmt))) > 5
			--exclude new items scanned to trigger initial holds
			JOIN sierra_view.record_metadata rm
				ON i.id = rm.id
				AND h.on_holdshelf_gmt::DATE - rm.creation_date_gmt::DATE >=4
			)
	END AS placed_on_holdshelf

FROM sierra_view.location_myuser l
JOIN transit t
	ON (l.code = t.origin_loc OR l.code = t.destination_loc) AND l.code NOT IN ('trn','mti')
JOIN sierra_view.item_record i
	ON t.id = i.id
JOIN sierra_view.varfield v
		ON t.id = v.record_id AND v.varfield_type_code = 'm' AND v.field_content LIKE '%IN TRANSIT%'

GROUP BY 1,2,l.code
ORDER BY 1,2