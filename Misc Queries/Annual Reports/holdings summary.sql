/*
Jeremy Goldstein
Minuteman Library Network

Holdings summary generated as part of annual reports
*/
SELECT
SUBSTRING(i.location_code,1,2) AS Code,
l.NAME AS Library,
count(i.id)

FROM
sierra_view.item_record i
JOIN
sierra_view.location_myuser l
ON
i.location_code = l.code AND i.itype_code_num != '80'

GROUP BY
1,2

ORDER BY
1,2
