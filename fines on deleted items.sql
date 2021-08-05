SELECT
*

FROM
sierra_view.fine f
JOIN
sierra_view.record_metadata rm
ON
f.item_record_metadata_id = rm.id AND rm.deletion_date_gmt IS NOT NULL