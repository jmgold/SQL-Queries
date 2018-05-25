SELECT
record_type_code,
COUNT(id)
FROM
sierra_view.record_metadata
WHERE
deletion_date_gmt IS NULL
GROUP BY 1;