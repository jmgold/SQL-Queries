SELECT
EXTRACT('year' FROM rm.creation_date_gmt) AS created,
COUNT(p.id) FILTER(WHERE rm.creation_date_gmt - p.birth_date_gmt< '12 years') AS new_patrons_under_12,
COUNT(p.id) FILTER(WHERE rm.creation_date_gmt - p.birth_date_gmt>= '12 years') AS new_patrons_12plus
FROM
sierra_view.patron_view p
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id AND p.barcode LIKE '24872%'
GROUP BY 1
