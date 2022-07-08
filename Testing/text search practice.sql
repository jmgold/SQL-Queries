WITH subject_list AS(
SELECT DISTINCT ON (i.icode1, d.index_entry)
i.icode1 AS scat,
d.index_entry AS subject
FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.phrase_entry d
ON
l.bib_record_id = d.record_id AND d.index_tag = 'd'


WHERE
i.location_code ~ '^cam'
AND i.icode1 >= 100
)

SELECT
subject,
to_tsvector(subject)
FROM
subject_list
WHERE
--to_tsvector(subject) @@ to_tsquery('juvenile <-> fiction')
to_tsvector(subject) @@ websearch_to_tsquery('"juvenile fiction" (dogs or cats) -pet')