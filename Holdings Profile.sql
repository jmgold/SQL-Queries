/*
Jeremy Goldstein
Minuteman Library Network

Holdings Profile gathered for annual reports
*/

SELECT
i.location_code,
i.itype_code_num,
count(i.id)

FROM
sierra_view.item_record as i

GROUP BY
1,2

ORDER BY
1,2
