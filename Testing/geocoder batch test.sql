SELECT
DISTINCT (p.id) AS id,
p.addr1 AS street,
p.city AS city,
p.region AS "state",
p.postal_code AS zip

FROM
sierra_view.circ_trans t
JOIN
sierra_view.patron_record_address p
ON
t.patron_record_id = p.patron_record_id AND t.transaction_gmt::DATE BETWEEN '2020-11-15' AND '2020-11-21'

WHERE
t.op_code ~ '^n|h'

LIMIT 10000 OFFSET {{offset}}