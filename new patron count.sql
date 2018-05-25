SELECT
p.ptype_code,
to_char(m.creation_date_gmt,'Mon DD'),
COUNT(p.id)
FROM
sierra_view.patron_view p
JOIN
sierra_view.record_metadata m
ON
p.record_num = m.record_num AND m.record_type_code = 'p'
WHERE
m.creation_date_gmt > (localtimestamp - interval '30 days')
GROUP BY 1,2
ORDER BY 1,2