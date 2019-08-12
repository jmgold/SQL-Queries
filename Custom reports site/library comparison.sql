/*
Jeremy Goldstein
Minuteman Library Network

Gathers the top titles owned by a selected peer library that are not owned locally, grouped by a choice of performance metrics
*/

SELECT
'b'||mb.record_num||'a' AS bib_number,
b.best_title AS title,
b.best_author AS author,
{{grouping}}

/*
Grouping options
AVG(ROUND((CAST((i.checkout_total * 14) AS NUMERIC (12,2)) / (CURRENT_DATE - m.creation_date_gmt::DATE)),6)) FILTER (WHERE m.creation_date_gmt::DATE != CURRENT_DATE) AS utilization
ROUND(CAST(SUM(i.checkout_total) + SUM(i.renewal_total) AS NUMERIC (12,2))/CAST(COUNT (i.id) AS NUMERIC (12,2)), 2) AS turnover
ROUND((COUNT(i.id) * (AVG(i.price) FILTER(WHERE i.price>'0' AND i.price <'10000'))/(NULLIF((SUM(i.checkout_total) + SUM(i.renewal_total)),0))),2) AS cost_per_circ
SUM(i.checkout_total) + SUM(i.renewal_total) AS total_circulation
SUM(i.checkout_total) AS total_checkouts
SUM(i.year_to_date_checkout_total) AS total_year_to_date_checkouts
SUM(i.last_year_to_date_checkout_total) AS total_last_year_to_date_checkouts
h.count_holds_on_title AS total_holds
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
(SELECT
t.bib_record_id,
count(t.bib_record_id) as count_holds_on_title
FROM
(SELECT
h.pickup_location_code,
h.record_id,
r.record_type_code, 
r.record_num,
--reconciles bib,item and volume level holds
CASE
    WHEN r.record_type_code = 'i' THEN (
        SELECT
        l.bib_record_id
        FROM
        sierra_view.bib_record_item_record_link as l
        WHERE
        l.item_record_id = h.record_id
        LIMIT 1
    )
    WHEN r.record_type_code = 'j' THEN (
        SELECT
        l.bib_record_id
        FROM
        sierra_view.bib_record_volume_record_link as l
        WHERE
        l.volume_record_id = h.record_id
        LIMIT 1
    )
    WHEN r.record_type_code = 'b' THEN (
        h.record_id
    )
    ELSE NULL
END AS bib_record_id

FROM
sierra_view.hold as h

JOIN
sierra_view.record_metadata as r
ON
  r.id = h.record_id) AS t
GROUP BY 1
HAVING
count(t.bib_record_id) > 1
) AS h
ON
b.bib_record_id = h.bib_record_id

WHERE
b.material_code IN ({{mat_type}})
GROUP BY
1,2,3,h.count_holds_on_title
HAVING
COUNT(i.id) FILTER (WHERE i.location_code ~ {{location}}) = 0
AND COUNT(i.id) FILTER (WHERE i.location_code ~ {{comp_location}} AND m.creation_date_gmt::DATE < {{created_date}}) > 0
ORDER BY 4 DESC
LIMIT {{qty}}