SELECT
rmi.creation_date_gmt::DATE AS item_created,
rmb.record_type_code||rmb.record_num||'a' AS bib_number,
rmi.record_type_code||rmi.record_num||'a' AS item_number,
rmo.record_type_code||rmo.record_num||'a' AS order_number,
o.order_status_code,
o.received_date_gmt::DATE AS received_date


FROM
sierra_view.bib_record_item_record_link l
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code ~ '^nee'
JOIN
sierra_view.record_metadata rmi
ON
i.id = rmi.id AND rmi.creation_date_gmt::DATE >= '2023-11-05'
JOIN
sierra_view.bib_record_order_record_link lo
ON
l.bib_record_id = lo.bib_record_id
JOIN
sierra_view.order_record o
ON
lo.order_record_id = o.id AND o.accounting_unit_code_num = '28' AND o.order_status_code = 'o'
JOIN
sierra_view.record_metadata rmo
ON
o.id = rmo.id
JOIN
sierra_view.record_metadata rmb
ON
lo.bib_record_id = rmb.id

ORDER BY 1,2