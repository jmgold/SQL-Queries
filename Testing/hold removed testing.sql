SELECT DISTINCT ON (reason, h.patron_record_id, h.record_id)
CASE
	WHEN h.holdshelf_status = 'c' THEN 'cancelled_on_shelf'
	WHEN h.holdshelf_status = 'p' THEN 'picked_up_on_shelf'
	WHEN h.holdshelf_status IS NULL AND h.removed_gmt::DATE >= h.expire_holdshelf_gmt::DATE THEN 'expired_holdshelf'
	WHEN h.expires_gmt::DATE <= h.removed_gmt::DATE THEN 'expired'
	WHEN hold.placed_gmt::DATE = h.removed_gmt::DATE THEN 'hold_transfered'
	WHEN t.transaction_gmt::DATE = h.removed_gmt::DATE THEN 'picked_up'
	WHEN h.removed_by_program ~ '^webpac' THEN 'cancelled_not_on_shelf'
	ELSE 'other'
END AS reason,
h.patron_record_id,
h.record_id,
h.pickup_location_code,
h.holdshelf_status,
h.removed_gmt,
h.status,
h.removed_by_process,
h.removed_by_program,
t.transaction_gmt,
hold.placed_gmt


FROM
sierra_view.hold_removed h
LEFT JOIN
sierra_view.hold
ON
h.patron_record_id = hold.patron_record_id AND h.record_id = hold.record_id AND h.placed_gmt != hold.placed_gmt
JOIN
sierra_view.record_metadata rm
ON
h.record_id = rm.id
JOIN
sierra_view.bib_record_item_record_link l
ON
CASE
	WHEN rm.record_type_code = 'b' THEN rm.id = l.bib_record_id
	ELSE rm.id = l.item_record_id
END
LEFT JOIN
sierra_view.circ_trans t
ON l.item_record_id = t.item_record_id AND t.op_code = 'o' AND t.transaction_gmt::DATE >= h.removed_gmt::DATE

WHERE --NOT (h.holdshelf_status IS NULL AND h.removed_gmt::DATE >= h.expire_holdshelf_gmt::DATE)
--AND h.holdshelf_status NOT IN ('c','p')
h.pickup_location_code = 'watz' AND h.removed_gmt::DATE = '2022-12-21'

ORDER BY 1