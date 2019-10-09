/*
Jeremy Goldstein
Minuteman Library network

Looks at current checkouts broken out by patrons of a library and mattype
shows the percentage of checkouts that are on time, overdue, and lost
*/

SELECT
CASE
WHEN p3.code NOT IN ('1','3','4','7','9','19','21','27','28','29','30','35','36','37','43','47','50','51','61','62','63','64','69','75','76','79','83','95','98','102','103','113','114','115','116','119','120','124','126','129','130') THEN '_Non_MLN'
ELSE p3.name 
END AS library,
M.name AS mat_type,
COUNT(DISTINCT C.id) AS total_current_checkouts,
COUNT(DISTINCT C.id) FILTER(WHERE C.due_gmt::DATE < NOW()::DATE) AS total_overdue,
round(cast(COUNT(DISTINCT C.id) FILTER(WHERE C.due_gmt::DATE < NOW()::DATE) as numeric (12,2)) / COUNT(DISTINCT C.id),4) AS pct_overdue,
COUNT(DISTINCT c.id) FILTER(WHERE f.charge_code IN ('3','5')) AS total_lost,
round(cast(COUNT(DISTINCT C.id) FILTER(WHERE f.charge_code IN ('3','5')) as numeric (12,2)) / COUNT(DISTINCT C.id),4) AS pct_lost,
COUNT(DISTINCT p.id) AS total_patrons,
COUNT(DISTINCT p.id) FILTER(WHERE C.due_gmt::DATE < NOW()::DATE) AS total_patrons_with_overdue,
round(cast(COUNT(DISTINCT p.id) FILTER(WHERE C.due_gmt::DATE < NOW()::DATE) as numeric (12,2)) / COUNT(DISTINCT p.id),4) AS pct_with_overdue,
COUNT(DISTINCT p.id) FILTER(WHERE f.charge_code IN ('3','5')) AS total_patrons_with_lost,
round(cast(COUNT(DISTINCT p.id) FILTER(WHERE f.charge_code IN ('3','5')) as numeric (12,2)) / COUNT(DISTINCT p.id),4) AS pct_with_lost

FROM
sierra_view.checkout C
JOIN
sierra_view.bib_record_item_record_link l
ON
C.item_record_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.patron_record p
ON
C.patron_record_id = p.id
JOIN
sierra_view.user_defined_pcode3_myuser p3
ON
p.pcode3::varchar = p3.code::VARCHAR
JOIN
sierra_view.material_property_myuser M
ON
b.material_code = M.code
LEFT JOIN
sierra_view.fine f
ON
C.item_record_id = f.item_record_metadata_id AND C.patron_record_id = f.patron_record_id

GROUP BY 1,2
ORDER BY 1,2