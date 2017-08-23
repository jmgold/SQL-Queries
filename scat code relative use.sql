SELECT
icode1 AS "Scat",
count (id) AS "Item_Count",
round(cast(count (id) as numeric (12,2)) / ((select cast(count (id)as numeric (12,2)) from sierra_view.item_view where location_code LIKE 'fpl%')), 8) AS "Relative_Item_Total"
FROM
sierra_view.item_record
WHERE
location_code LIKE 'fpl%' 
GROUP BY 1
ORDER BY 1