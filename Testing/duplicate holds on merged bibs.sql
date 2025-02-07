SELECT
DISTINCT h.id,
t.transaction_gmt AS circ_transaction,
h.placed_gmt AS hold_placed,
t.patron_record_id,
t.bib_record_id,
l.bib_record_id

FROM
sierra_view.circ_trans t
JOIN
sierra_view.hold h
ON t.op_code ~ '^(n|h)' AND t.patron_record_id = h.patron_record_id AND t.transaction_gmt = h.placed_gmt
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.bib_record_id OR h.record_id = l.item_record_id

WHERE
l.bib_record_id != t.bib_record_id

LIMIT 100