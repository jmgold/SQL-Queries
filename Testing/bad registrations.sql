--identifies patron records exhibiting various common data entry errors
SELECT
m.record_type_code||m.record_num||'a' AS record_num,
m.creation_date_gmt,
z.index_entry AS email,
w.index_entry AS altid,
p.ptype_code AS ptype,
a.addr1 AS street_address,
a.city,
n.first_name,
n.middle_name,
n.last_name,
t.phone_number

FROM
sierra_view.patron_record AS p
--telephone field
JOIN
sierra_view.patron_record_phone AS t
ON
p.id = t.patron_record_id AND t.patron_record_phone_type_id = '1'
--alt telephone field
JOIN
sierra_view.phrase_entry z
ON
p.id = z.record_id AND z.varfield_type_code = 'z'
JOIN
sierra_view.phrase_entry w
ON
p.id = w.record_id AND w.varfield_type_code = 'w'
JOIN
sierra_view.patron_record_address as a
ON p.id = a.patron_record_id
JOIN
sierra_view.record_metadata m
ON
p.id = m.id and m.record_type_code = 'p' --and m.creation_date_gmt > (localtimestamp - interval '1 month')
JOIN
sierra_view.patron_record_fullname n
ON
p.id = n.patron_record_id AND n.middle_name ~ '^[A-Za-z]{2,}$' AND n.first_name ~ '^[A-Za-z]{2,}$' AND n.last_name ~ '^[A-Za-z]{2,}$'
WHERE
p.patron_agency_code_num = '47'
AND p.ptype_code = '207'
AND a.addr1 ~'^[A-Za-z]+$'
AND a.city ~'^[A-Za-z]+$'
AND a.postal_code IS NULL
AND a.region = ''
AND t.phone_number ~ '\d{10}'
AND m.creation_date_gmt::DATE >= '2022-07-18'

ORDER BY
2,1
