SELECT
i.location_code,
i.itype_code_num,
count(i.itype_code_num)

FROM
sierra_view.item_view as i

GROUP BY
i.itype_code_num,
i.location_code

ORDER BY
i.location_code,
i.itype_code_num
