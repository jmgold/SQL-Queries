/*
Jeremy Goldstein
Minuteman Library NETWORK

Generates weekly circulation file for uploading to OrangeBoy's Savanah platform
*/

SELECT
rm.record_num AS PatronId,
b.index_entry AS barcode,
bp.material_code AS mat_type,
o.itype_code_num AS item_type,
o.stat_group_code_num AS checkout_location,
i.location_code AS item_location,
o.transaction_gmt AS checkout_time,
C.renewal_count AS renewals,
C.due_gmt AS duedate


FROM
sierra_view.circ_trans o
JOIN
sierra_view.record_metadata rm
ON
o.patron_record_id = rm.id
JOIN
sierra_view.phrase_entry b
ON
rm.id = b.record_id AND b.varfield_type_code = 'b' AND b.occurrence = 0
JOIN
sierra_view.bib_record_item_record_link l
ON
o.item_record_id = l.item_record_id
JOIN
sierra_view.bib_record_property bp
ON
l.bib_record_id = bp.bib_record_id
JOIN
sierra_view.item_record i
ON
o.item_record_id = i.id
LEFT JOIN
sierra_view.checkout C
ON
o.item_record_id = C.item_record_id AND o.patron_record_id = C.patron_record_id AND o.transaction_gmt = C.checkout_gmt


WHERE
o.op_code = 'o'
AND o.ptype_code IN ('29','129')
AND o.stat_group_code_num BETWEEN '590' AND '599'
AND o.transaction_gmt::DATE >= CURRENT_DATE - INTERVAL '1 week'
ORDER BY o.transaction_gmt

