SELECT
n.last_name||', '||n.first_name||' '||n.middle_name AS name,
REGEXP_REPLACE(i.call_number,'\|[a-z]',' ','g') AS call_number,
i.barcode,
b.best_title AS title,
b.best_author AS author


FROM
sierra_view.hold h
JOIN
sierra_view.patron_record_fullname n
ON
h.patron_record_id = n.patron_record_id
JOIN
sierra_view.item_record_property i
ON
h.record_id = i.item_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id

WHERE
h.pickup_location_code = 'wobz' AND h.status IN ('b','i')

ORDER BY 1
