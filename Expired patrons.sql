SELECT
min(n.first_name),
min(n.last_name),
min(v.field_content) as email,
to_char(p.expiration_date_gmt,'Mon DD, YYYY'),
p.id
FROM
sierra_view.patron_view as p
JOIN		
sierra_view.varfield v		
ON		
p.id = v.record_id and v.varfield_type_code = 'z'
JOIN
sierra_view.patron_record_fullname n
ON
p.id = n.patron_record_id
WHERE
p.expiration_date_gmt::date = (localtimestamp::date - '1 day')
group by 5, 4
