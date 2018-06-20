SELECT
i.location_code,
i.item_status_code,
count(i.item_status_code)

FROM
sierra_view.item_view as i

GROUP BY
i.item_status_code,
i.location_code

ORDER BY
i.location_code,
i.item_status_code
