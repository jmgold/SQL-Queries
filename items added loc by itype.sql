SELECT
i.location_code,
i.itype_code_num,
count(i.itype_code_num)

FROM
sierra_view.item_view as i

WHERE
i.record_creation_date_gmt::date >= '2017-07-01'

GROUP BY
i.itype_code_num,
i.location_code

ORDER BY
i.location_code,
i.itype_code_num