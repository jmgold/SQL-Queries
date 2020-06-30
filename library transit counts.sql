WITH transit AS (
SELECT
v.id AS id,
SUBSTRING(SPLIT_PART(SPLIT_PART(v.field_content,'from ',2),' to',1)FROM 1 FOR 3) AS origin_loc,
SUBSTRING(SPLIT_PART(v.field_content,'to ',2) FROM 1 FOR 3) AS destination_loc
FROM
sierra_view.item_record i
JOIN sierra_view.varfield v
ON
i.id = v.record_id AND v.varfield_type_code = 'm' AND v.field_content LIKE '%IN TRANSIT%'
WHERE
i.item_status_code = 't')

SELECT
to_char(NOW(),'YYYY-MM-DD') AS "date",
l.name AS library,
COUNT(DISTINCT t.id) FILTER (WHERE t.origin_loc = l.code) AS transit_from,
COUNT(DISTINCT t.id) FILTER (WHERE t.destination_loc = l.code) AS transit_to,
(SELECT 
COUNT(h.id) AS on_holdshelf
FROM
sierra_view.hold h
WHERE
SUBSTRING(h.pickup_location_code,1,3) = l.code AND h.status IN ('b','i'))

FROM
sierra_view.location_myuser l
JOIN
transit t
ON
(l.code = t.origin_loc OR l.code = t.destination_loc) AND l.code NOT IN ('trn','mti')

GROUP BY 1,2,l.code
ORDER BY 1,2