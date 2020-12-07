SELECT
lang.name AS "language",
stat_group_code_num,
SUBSTRING(a.postal_code FROM 1 FOR 5) AS zip,
COUNT(DISTINCT t.id) AS checkout_total

FROM
sierra_view.circ_trans t
JOIN
sierra_view.patron_record p
ON
t.patron_record_id = p.id AND t.op_code = 'f'
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
t.item_record_id = l.item_record_id
JOIN
sierra_view.bib_record b
ON
l.bib_record_id = b.id AND b.language_code != 'eng'
JOIN
sierra_view.language_property_myuser lang
ON
b.language_code = lang.code

WHERE t.stat_group_code_num BETWEEN '210' AND '299'

GROUP BY 1,2,3

ORDER BY 1,2,3