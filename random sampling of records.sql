--Produces random sample of unsuppressed bib records to be imported into review file for use
SELECT
concat(
	rm.record_type_code,
	rm.record_num||'a'
	)
FROM
sierra_view.bib_record AS b
JOIN
sierra_view.record_metadata AS rm
ON
rm.id = b.record_id
WHERE
b.is_suppressed IS FALSE
ORDER BY
RANDOM()
LIMIT 1000;