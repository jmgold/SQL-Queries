SELECT
*
FROM
sierra_view.record_metadata
WHERE
deletion_date_gmt IS NULL
AND
campus_code = 'ncip'
ORDER BY 2,4;