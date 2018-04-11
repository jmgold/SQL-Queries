--Jeremy Goldstein
--Minuteman Library Network

--Capture how many items are using each status code
--Primary use: get number of withdrawn, billed, missing, etc... items included in annual holdings count

SELECT
CASE
WHEN item_status_code = '-' THEN 'AVAILABILE'
WHEN item_status_code = 'm' THEN 'MISSING'
WHEN item_status_code = 'n' THEN 'BILLED'
WHEN item_status_code = 'z' THEN 'CLMS RETD'
WHEN item_status_code = 't' THEN 'IN TRANSIT'
WHEN item_status_code = 's' THEN 'ON SEARCH'
WHEN item_status_code = 'o' THEN 'LIB USE ONLY'
WHEN item_status_code = '$' THEN 'LOST AND PAID'
WHEN item_status_code = '!' THEN 'ON HOLDSHELF'
WHEN item_status_code = 'w' THEN 'WITHDRAWN'
WHEN item_status_code = 'd' THEN 'DAMAGED'
WHEN item_status_code = 'p' THEN 'IN PROCESSING'
WHEN item_status_code = 'g' THEN 'MENDING'
WHEN item_status_code = 'b' THEN 'BINDERY'
WHEN item_status_code = 'a' THEN 'AV REPAIR'
WHEN item_status_code = 'i' THEN 'INCOMPLETE'
WHEN item_status_code = 'r' THEN 'ON ORDER'
WHEN item_status_code = 'e' THEN 'E-RESOURCE'
WHEN item_status_code = 'j' THEN 'PERIODICAL'
WHEN item_status_code = 'x' THEN 'ON DISPLAY 1'
WHEN item_status_code = 'y' THEN 'ON DISPLAY 2'
WHEN item_status_code = 'v' THEN 'ON DISPLAY 3'
WHEN item_status_code = 'u' THEN 'BROWSE'
WHEN item_status_code = 'q' THEN 'STORAGE'
ELSE 'unexpected code '||item_status_code
END AS "Status",
count (id) as "Item_total"
FROM
sierra_view.item_record
GROUP BY 1
ORDER BY 1;
