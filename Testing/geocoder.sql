SELECT
DISTINCT p.id,
a.addr1,
a.addr2,
a.city,
a.region,
a.postal_code
FROM
sierra_view.patron_record p
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id

WHERE
p.ptype_code = '12'