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
p.expiration_date_gmt::DATE = BETWEEN '2022-02-20' AND '2022-04-22'--= (localtimestamp::date - interval '1 day')
AND p.ptype_code NOT IN('207','255') 
--p.barcode in ('21213002946238','21213002957888','24868041084775','123456789')
group by 5, 4
--LIMIT 200
--OFFSET 2249