SELECT
CASE
	WHEN s.content = '' THEN s.content
	ELSE s.content||c.content||t.content||SUBSTRING(b.content,1,1)
END AS geoid,
COUNT(p.id) AS patron_count,
SUM(p.checkout_total) AS checkout_total,
ROUND(AVG(DATE_PART('year',AGE(CURRENT_DATE,p.birth_date_gmt::DATE)))) AS avg_age

FROM
sierra_view.patron_record p
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

GROUP BY 1
ORDER BY 2 DESC