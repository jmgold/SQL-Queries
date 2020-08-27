SELECT
DISTINCT id2reckey(h.patron_record_id)||'a' AS patron_number,
COALESCE(s.content,'') AS email,
p.last_name||', '||p.first_name||' '||p.middle_name AS name,
COALESCE(ph1.phone_number,'') AS phone,
COALESCE(ph2.phone_number,'') AS phone2,
STRING_AGG(b.best_title, ', ') AS titles

FROM
sierra_view.hold h
LEFT JOIN
sierra_view.subfield s
ON
h.patron_record_id = s.record_id AND s.field_type_code = 'z' AND s.occ_num = 0
JOIN
sierra_view.patron_record_fullname p
ON
h.patron_record_id = p.patron_record_id AND p.display_order = '0'
LEFT JOIN
sierra_view.patron_record_phone ph1
ON
h.patron_record_id = ph1.patron_record_id AND ph1.display_order = 0 AND ph1.patron_record_phone_type_id = '1'
LEFT JOIN
sierra_view.patron_record_phone ph2
ON
h.patron_record_id = ph2.patron_record_id AND ph2.display_order = 0 AND ph2.patron_record_phone_type_id = '2'
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.record_metadata rm
ON
h.record_id = rm.id AND rm.record_type_code = 'i' AND rm.record_last_updated_gmt::DATE >= NOW()::DATE - INTERVAL '2 days'

WHERE h.pickup_location_code ~ 'mayz'
AND h.status IN ('b','i')
GROUP BY 1,2,3,4,5

ORDER BY 3