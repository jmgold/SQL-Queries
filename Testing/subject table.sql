SELECT 
d.id,
d.record_id,
d.occurrence,
d.index_entry,
trim(regexp_replace(RIGHT(d.insert_title, LENGTH(d.insert_title) - 1), '\s+', ' ', 'g')) AS title

FROM
sierra_view.phrase_entry d
JOIN
sierra_view.record_metadata rm
ON
d.record_id = rm.id AND d.index_tag = 'd'
AND rm.record_type_code = 'b'
AND d.is_permuted = FALSE