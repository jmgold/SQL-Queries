--Finds records that share 001 fields

SELECT
    id2reckey(record_id) AS rid,
    index_entry
FROM
    sierra_view.phrase_entry
WHERE
    index_tag = 'o' AND
    index_entry IN (
        SELECT
            index_entry
        FROM
            sierra_view.phrase_entry
        WHERE
            index_tag = 'o'
        GROUP BY
            index_entry
        HAVING
            count(id) > 1)
ORDER BY
    index_entry, rid