WITH hold_count AS
	(SELECT
	l.bib_record_id,
	COUNT(DISTINCT h.id) AS count_holds_on_title,
	COUNT(DISTINCT h.id) FILTER (WHERE h.pickup_location_code ~ '^shr') AS count_local_holds_on_title
	--reconciles bib,item and volume level holds

	FROM
	sierra_view.hold h
	JOIN
	sierra_view.bib_record_item_record_link l
	ON
	h.record_id = l.item_record_id OR h.record_id = l.bib_record_id

	GROUP BY 1
	HAVING
	COUNT(DISTINCT h.id) > 1
)

SELECT
id2reckey(b.bib_record_id)||'a' AS bib_number,
b.best_title AS title,
b.best_author AS author,
COUNT(DISTINCT i.id) AS total_items,
h.count_holds_on_title AS total_holds,
COUNT(DISTINCT h.count_holds_on_title) / (NULLIF(COUNT(DISTINCT i.id),0)) AS network_hold_to_item_ratio,
ROUND(CAST(h.count_holds_on_title AS NUMERIC (12, 2))/CAST(COUNT(DISTINCT i.id) AS numeric(12,2)),2),
COUNT(DISTINCT i.id) FILTER (WHERE i.location_code ~ '^shr') total_local_items,
h.count_local_holds_on_title AS total_local_holds,
COUNT(DISTINCT h.count_local_holds_on_title)/(NULLIF(COUNT(DISTINCT i.id),0)) AS local_hold_to_total_item_ratio,
COUNT(DISTINCT h.count_local_holds_on_title)/((NULLIF(COUNT(DISTINCT i.id) FILTER(WHERE i.location_code ~ '^shr'),0))) AS local_hold_to_total_item_ratio

FROM
hold_count h
JOIN
sierra_view.bib_record_property b
ON
h.bib_record_id = b.bib_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
LEFT JOIN
sierra_view.item_record i
ON
i.id = l.item_record_id-- AND i.location_code ~ '{{location}}' 


GROUP BY 1,2,3,5,9

ORDER BY 5 DESC