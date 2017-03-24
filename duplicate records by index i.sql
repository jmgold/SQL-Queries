-- based on query by David Jones and shared over Sierra listserv 9/20/16
-- Finds records that share i indexed fields

SELECT
    id2reckey(p.record_id)||'a' AS rid,
    p.index_entry
FROM
    sierra_view.phrase_entry as p
JOIN
    sierra_view.bib_record as b
ON
    p.record_id=b.record_id
WHERE
--presently limited to e-books
    p.index_tag = 'i' AND b.bcode2='h'AND
    
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
    index_entry, rid
