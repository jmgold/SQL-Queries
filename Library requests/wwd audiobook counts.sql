SELECT
i.itype_code_num,
COUNT (i.id)
FROM
sierra_view.item_record i
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
WHERE
i.location_code ~ '^ww' AND i.itype_code_num IN ('36', '37','125','173')
AND ip.call_number_norm !~ '^great courses'

GROUP BY 1