SELECT
p.pcode4,
m.creation_date_gmt
FROM
sierra_view.patron_view p
JOIN
sierra_view.record_metadata m
ON
p.record_num = m.record_num AND m.record_type_code = 'p'
WHERE
m.creation_date_gmt > '2016-08-31'
AND p.home_library_code LIKE 'ww%'