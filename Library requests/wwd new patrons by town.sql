SELECT
p3.name AS "MA Town",
COUNT(p.id) FILTER(WHERE p.ptype_code = '39') AS "Total by ptype",
COUNT(p.id) FILTER(WHERE p.barcode ~ '^23018') AS "Total by barcode"
FROM
sierra_view.patron_view p
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id AND EXTRACT(YEAR FROM rm.creation_date_gmt) = '2019'
JOIN
sierra_view.user_defined_pcode3_myuser p3
ON
p.pcode3::VARCHAR = p3.code
WHERE p.barcode ~ '^23018' OR p.ptype_code = '39'
GROUP BY 1