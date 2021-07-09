SELECT
b.best_title,
ip.barcode,
i.icode1

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id

WHERE i.location_code ~ '^ntn'