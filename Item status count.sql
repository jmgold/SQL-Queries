--Capture how many items are using each status code
--Primary use: get number of withdrawn, billed, missing, etc... items included in annual holdings count

SELECT
item_status_code AS "Status",
count (id) as "Item_total"
FROM
sierra_view.item_record
GROUP BY 1
ORDER BY 1;