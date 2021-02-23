SELECT
--SUBSTRING(a.postal_code,'^\d{5}') AS zip,

CASE
	WHEN s.content = '' THEN s.content
	ELSE s.content||c.content||t.content||SUBSTRING(b.content,1,1)
END AS geoid,
CASE
	WHEN i.location_code ~ '^ar' THEN 'local'
	ELSE 'network transfer'
END AS item_ownership,
COUNT(ct.id) AS checkout_total

FROM
sierra_view.circ_trans ct
JOIN
sierra_view.patron_record p
ON
ct.patron_record_id = p.id
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id
AND LOWER(a.addr1) !~ '^p\.?\s?o'
AND a.patron_record_address_type_id = '1'
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
JOIN
sierra_view.item_record i
ON
ct.item_record_id = i.id

WHERE p.ptype_code IN ('2') AND ct.op_code = 'o'

GROUP BY 1,2
ORDER BY 1,2