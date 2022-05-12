/*
Jeremy Goldstein
Minuteman Library Network
based on query by David Jones and shared over Sierra listserv 9/20/16
Finds records that share i indexed fields
*/
SELECT
rm.record_type_code||rm.record_num||'a' AS bnumber,
p.index_entry

FROM
sierra_view.phrase_entry AS p
JOIN
sierra_view.bib_record AS b
ON
p.record_id = b.record_id AND p.index_tag = 'i'
JOIN
sierra_view.record_metadata rm
ON
b.id = rm.id

WHERE
--presently limited to e-books
b.bcode2='h'AND
p.index_entry IN (

SELECT
p.index_entry

FROM
sierra_view.phrase_entry as p
WHERE
p.index_tag = 'i'
GROUP BY
p.index_entry
HAVING
count(p.id) > 1)
ORDER BY
p.index_entry, rm.record_num
