SELECT
SUBSTRING(a.postal_code,'^\d{5}') AS zip,
/*
--replace zip with block group
CASE
	WHEN s.content = '' THEN s.content
	ELSE s.content||c.content||t.content||SUBSTRING(b.content,1,1)
END AS geoid,
*/
COUNT(DISTINCT p.id) AS patron_count,
SUM(p.checkout_total) AS checkout_total,
SUM(p.renewal_total) AS renewal_total,
SUM(p.checkout_total + p.renewal_total) AS circ_total,
SUM(p.checkout_count) AS current_checkout_total,
COUNT(DISTINCT h.id) AS current_hold_total,
ROUND(AVG(DATE_PART('year',AGE(CURRENT_DATE,p.birth_date_gmt::DATE)))) AS avg_age,
COUNT(DISTINCT p.id) FILTER(WHERE rm.creation_date_gmt::DATE >= CURRENT_DATE - INTERVAL '1 year') AS new_patron_count,
COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE >= CURRENT_DATE - INTERVAL '1 year') AS active_patron_count,
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE >= CURRENT_DATE - INTERVAL '1 year') AS NUMERIC (12,2))) / CAST(COUNT(DISTINCT p.id) AS NUMERIC (12,2)), 4) ||'%' AS pct_active,
MODE() WITHIN GROUP(order by(p.activity_gmt::DATE))AS avg_last_active_date,
COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) as total_blocked_patrons,
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) as numeric (12,2)) / cast(COUNT(DISTINCT p.id) as numeric (12,2))),4) ||'%' AS pct_blocked

FROM
sierra_view.patron_record p
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id
AND LOWER(a.addr1) !~ '^p\.?\s?o'
AND a.patron_record_address_type_id = '1'
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id
LEFT JOIN
sierra_view.hold h
ON
p.id = h.patron_record_id
/*
for census field
JOIN
sierra_view.subfield s
ON
s.record_id = p.id AND s.field_type_code = 'k' AND s.tag = 's'
JOIN
sierra_view.subfield c
ON
c.record_id = p.id AND c.field_type_code = 'k' AND c.tag = 'c'
JOIN
sierra_view.subfield t
ON
t.record_id = p.id AND t.field_type_code = 'k' AND t.tag = 't'
JOIN
sierra_view.subfield b
ON
b.record_id = p.id AND b.field_type_code = 'k' AND b.tag = 'b'
*/

WHERE p.ptype_code IN ('12')

GROUP BY 1
ORDER BY 2 DESC