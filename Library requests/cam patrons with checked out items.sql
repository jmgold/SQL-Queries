SELECT
DISTINCT id2reckey(o.patron_record_id)||'a' AS patron_number,
COALESCE(e.content,'') AS email,
p.last_name||', '||p.first_name||' '||p.middle_name AS name,
COALESCE(ph1.phone_number,'') AS phone,
COALESCE(ph2.phone_number,'') AS phone2,
STRING_AGG(b.best_title, ', ') AS titles

FROM
sierra_view.checkout o
JOIN
sierra_view.item_record i
ON
o.item_record_id = i.id
JOIN
sierra_view.statistic_group_myuser s
ON
i.checkout_statistic_group_code_num = s.code
LEFT JOIN
sierra_view.subfield e
ON
o.patron_record_id = e.record_id AND e.field_type_code = 'z' AND e.occ_num = 0
JOIN
sierra_view.patron_record_fullname p
ON
o.patron_record_id = p.patron_record_id AND p.display_order = '0'
LEFT JOIN
sierra_view.patron_record_phone ph1
ON
o.patron_record_id = ph1.patron_record_id AND ph1.display_order = 0 AND ph1.patron_record_phone_type_id = '1'
LEFT JOIN
sierra_view.patron_record_phone ph2
ON
o.patron_record_id = ph2.patron_record_id AND ph2.display_order = 0 AND ph2.patron_record_phone_type_id = '2'
JOIN
sierra_view.bib_record_item_record_link l
ON
o.item_record_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id

WHERE o.due_gmt::DATE = '2020-07-31' AND o.checkout_gmt::DATE <= '2020-03-14'
AND i.checkout_statistic_group_code_num BETWEEN '210' AND '219'
AND i.item_status_code NOT IN ('n','$')
GROUP BY 1,2,3,4,5

ORDER BY 3
