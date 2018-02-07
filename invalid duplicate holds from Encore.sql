--Finds duplicate holds made in error in Encore
SELECT
id
FROM
sierra_view.hold
WHERE
expires_gmt is null
GROUP BY
record_id, patron_record_id, id
HAVING
count(*) > 1