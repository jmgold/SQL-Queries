SELECT
d.index_entry,
COUNT(b.id)
FROM
sierra_view.phrase_entry d
JOIN
sierra_view.bib_record b 
ON
d.record_id = b.id AND d.index_tag = 'd'
JOIN
sierra_view.subfield s
ON
b.id = s.record_id AND s.field_type_code = 'd'

WHERE
REPLACE(LOWER(s.content),'-',' ') ~ 'india' AND REPLACE(LOWER(s.content),'-',' ') !~ 'indian'

GROUP BY 1
ORDER BY 2 DESC