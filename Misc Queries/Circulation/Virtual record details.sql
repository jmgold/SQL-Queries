/*
Jeremy Goldstein
Minuteman Library Network

Provides details of virtual records in the system
Within Mass these are all items borrowed via the Commonwealth Catalog using AutoGraphics ILL
*/

SELECT
rmp.record_type_code||rmp.record_num||'a' AS pnumber,
rmi.record_type_code||rmi.record_num||'a' AS inumber,
rmb.record_type_code||rmb.record_num||'a' AS bnumber,
rmi.creation_date_gmt AS item_creation_date,
rmi.record_last_updated_gmt AS item_last_updated_date,
b.field_content AS barcode,
callnum.field_content AS call_number,
title.field_content AS title,
author.field_content AS author,
CASE
	WHEN o.id IS NOT NULL THEN 'CHECKOUT'
	WHEN h.id IS NOT NULL THEN 'HOLD'
END AS hold_or_checkout,
o.checkout_gmt AS checkout_date,
o.due_gmt AS due_date,
o.loanrule_code_num,
o.overdue_count,
h.placed_gmt AS hold_placed,
h.pickup_location_code,
CASE
	WHEN h.status = 't' THEN 'IN TRANSIT'
	WHEN h.status = '0' THEN 'ON HOLD'
	WHEN h.status IN ('b','i') THEN 'READY FOR PICKUP'
END AS hold_status,
h.on_holdshelf_gmt AS placed_on_holdshelf,
h.expire_holdshelf_gmt AS holdshelf_expiration_date


FROM
sierra_view.record_metadata rmi
JOIN
sierra_view.varfield b
ON
rmi.id = b.record_id AND b.varfield_type_code = 'b'
JOIN
sierra_view.varfield callnum
ON
rmi.id = callnum.record_id AND callnum.varfield_type_code = 'c'
JOIN
sierra_view.bib_record_item_record_link l
ON
rmi.id = l.item_record_id
JOIN
sierra_view.record_metadata rmb
ON
l.bib_record_id = rmb.id
LEFT JOIN
sierra_view.hold h
ON
rmi.id = h.record_id
LEFT JOIN
sierra_view.checkout o
ON
rmi.id = o.item_record_id
JOIN
sierra_view.varfield title
ON
rmb.id = title.record_id AND title.varfield_type_code = 't'
JOIN
sierra_view.varfield author
ON
rmb.id = author.record_id AND author.varfield_type_code = 'a'
LEFT JOIN
sierra_view.record_metadata rmp
ON
o.patron_record_id = rmp.id OR h.patron_record_id = rmp.id

WHERE
rmi.campus_code = 'ncip' AND rmi.record_type_code = 'i'

ORDER BY 10,1