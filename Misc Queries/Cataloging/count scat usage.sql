/*
Jeremy Goldstein
Minuteman Library network
counts number of items using each scat code within a specified agency
*/

SELECT
icode1 AS scat,
COUNT(*) AS item_total

FROM
sierra_view.item_record

--Specify your filter here
WHERE
agency_code_num = '1'

GROUP BY 1
ORDER BY 1
