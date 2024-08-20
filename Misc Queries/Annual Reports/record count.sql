SELECT
record_type_code,
COUNT(id)
FROM
sierra_view.record_metadata
WHERE
deletion_date_gmt IS NULL
AND
campus_code = ''
GROUP BY 1;
