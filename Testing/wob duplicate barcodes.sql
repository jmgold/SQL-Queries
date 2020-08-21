WITH barcode_count AS(
SELECT
i.barcode,
COUNT(i.id) AS barcode_count

FROM
sierra_view.item_record_property i
JOIN
sierra_view.item_record ir
ON
i.item_record_id = ir.id AND ir.location_code ~ '^wob'

WHERE i.barcode != ''
GROUP BY 1
)

SELECT
i.barcode,
rm.record_type_code||rm.record_num||'a',
rm.creation_date_gmt

FROM
sierra_view.item_record_property i
JOIN
barcode_count
ON
i.barcode = barcode_count.barcode AND barcode_count.barcode_count > 1
JOIN
sierra_view.record_metadata rm
ON
i.item_record_id = rm.id

ORDER BY 3