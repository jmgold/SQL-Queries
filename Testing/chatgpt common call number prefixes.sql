SELECT SUBSTRING(p.index_entry from 1 for position(' ' IN p.index_entry)) AS phrase, COUNT(*) AS count
FROM sierra_view.phrase_entry p
JOIN
sierra_view.record_metadata rm
ON
p.record_id = rm.id AND rm.record_type_code = 'i' AND p.index_tag = 'c'
WHERE p.index_entry ~ '^\w+(\s+\w+){1,2}' -- Filter out call_numbers that don't have at least 2 words
AND p.index_entry !~ '^\d'
GROUP BY phrase
ORDER BY count DESC
LIMIT 1000;