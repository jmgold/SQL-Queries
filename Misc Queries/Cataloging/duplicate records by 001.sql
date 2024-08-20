/*
Jeremy Goldstein
Minuteman Library Network
Based on query from David Jones shared over Sierra listserv 9/20/16
Finds bib records that share control # tagged fields
*/
SELECT
rm.record_type_code||rm.record_num||'a' AS bib_number,
p.index_entry AS control_number

FROM
sierra_view.phrase_entry p
JOIN
sierra_view.record_metadata rm
ON
p.record_id = rm.id
WHERE
p.index_tag = 'o' AND
p.index_entry IN (
	SELECT
	p.index_entry
	FROM
	sierra_view.phrase_entry p
	WHERE
	p.index_tag = 'o'
	GROUP BY
	p.index_entry
	HAVING
	COUNT(p.id) > 1
)

ORDER BY p.index_entry, rm.record_num
