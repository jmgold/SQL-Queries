/*
Jeremy Goldstein
Minuteman Library Network

Capture how many items are using each status code
*/

SELECT
s.name AS status,
s.code AS status_code,
COUNT(i.id) AS item_total

FROM
sierra_view.item_record i
JOIN
sierra_view.item_status_property_myuser s
ON
i.item_status_code = s.code

GROUP BY 1,2
ORDER BY 3 DESC
