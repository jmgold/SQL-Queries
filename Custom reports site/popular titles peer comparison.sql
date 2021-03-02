/*
Jeremy Goldstein
Minuteman Library Network

Gathers the top titles owned by a selected peer library that are not owned locally, grouped by a choice of performance metrics
*/
WITH hold_count AS
	(SELECT
	l.bib_record_id,
	COUNT(DISTINCT h.id) AS count_holds_on_title
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
'b'||mb.record_num||'a' AS bib_number,
b.best_title AS title,
b.best_author AS author,
b.publish_year,
CASE 
	WHEN '{{grouping}}' = 'Total Checkouts' THEN SUM(i.checkout_total) FILTER (WHERE i.location_code ~ '{{comp_location}}' AND m.creation_date_gmt::DATE < {{created_date}})
	WHEN '{{grouping}}' = 'Total Checkouts: Last Year' THEN SUM(i.last_year_to_date_checkout_total) FILTER (WHERE i.location_code ~ '{{comp_location}}' AND m.creation_date_gmt::DATE < {{created_date}})
	WHEN '{{grouping}}' = 'Total Checkouts: Year to Date' THEN SUM(i.year_to_date_checkout_total) FILTER (WHERE i.location_code ~ '{{comp_location}}' AND m.creation_date_gmt::DATE < {{created_date}})
	WHEN '{{grouping}}' = 'Total Checkouts: Last Year + Year to Date' THEN SUM(i.year_to_date_checkout_total + i.last_year_to_date_checkout_total) FILTER (WHERE i.location_code ~ '{{comp_location}}' AND m.creation_date_gmt::DATE < {{created_date}})
	WHEN '{{grouping}}' = 'Total Circulation' THEN SUM(i.checkout_total + i.renewal_total) FILTER (WHERE i.location_code ~ '{{comp_location}}' AND m.creation_date_gmt::DATE < {{created_date}})
	WHEN '{{grouping}}' = 'Total Holds' THEN COALESCE(h.count_holds_on_title,0)
	WHEN '{{grouping}}' = 'Turnover' THEN ROUND((CAST(SUM(i.checkout_total + i.renewal_total) FILTER (WHERE i.location_code ~ '{{comp_location}}' AND m.creation_date_gmt::DATE < {{created_date}}) AS NUMERIC (12,2))/CAST(COUNT (i.id) FILTER (WHERE i.location_code ~ '{{comp_location}}' AND m.creation_date_gmt::DATE < {{created_date}}) AS NUMERIC (12,2))), 2)
	WHEN '{{grouping}}' = 'Utilization' THEN AVG(ROUND((CAST((i.checkout_total * 14) AS NUMERIC (12,2)) / (CURRENT_DATE - m.creation_date_gmt::DATE)),6)) FILTER (WHERE m.creation_date_gmt::DATE != CURRENT_DATE AND i.location_code ~ '{{comp_location}}' AND m.creation_date_gmt::DATE < {{created_date}})
END AS popularity_metric

/*
Grouping options
Total Checkouts
Total Checkouts: Last Year
Total Checkouts: Year to Date
Total Checkouts: Last Year + Year to Date
Total Circulation
Total Holds
Turnover
Utilization
*/

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
i.id = l.item_record_id AND i.item_status_code NOT IN ({{item_status_codes}})
AND {{age_level}}
	/*
	SUBSTRING(i.location_code,4,1) NOT IN ('y','j') --adult
	SUBSTRING(i.location_code,4,1) = 'j' --juv
	SUBSTRING(i.location_code,4,1) = 'y' --ya
	i.location_code ~ '\w' --all
	*/
JOIN
sierra_view.record_metadata m
ON
i.id = m.id
JOIN
sierra_view.bib_record br
ON
l.bib_record_id = br.id
AND br.bcode3 NOT IN ('g','o','r','z','l','q','n')
JOIN
sierra_view.record_metadata mb
ON
b.bib_record_id = mb.id
LEFT JOIN
hold_count AS h
ON
b.bib_record_id = h.bib_record_id

WHERE
b.material_code IN ({{mat_type}})
GROUP BY
1,2,3,4,h.count_holds_on_title
HAVING
COUNT(i.id) FILTER (WHERE i.location_code ~ '{{location}}') = 0
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
AND COUNT(i.id) FILTER (WHERE i.location_code ~ '{{comp_location}}' AND m.creation_date_gmt::DATE < {{created_date}}) > 0
ORDER BY 5 DESC
LIMIT {{qty}}