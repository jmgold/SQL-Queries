/*
Jeremy Goldstein
Minuteman Library Network

Gathers monthly checkin and checkout totals for hotspots owned by Newton
for E-Rate reporting requirements
*/

SELECT
t.transaction_gmt::DATE AS transaction_date,
CASE
	WHEN t.op_code = 'o' THEN 'CHECKOUT'
	ELSE 'CHECKIN'
END AS transaction_type,
i.barcode,
v.field_content AS internal_note

FROM sierra_view.record_metadata rm
JOIN sierra_view.bib_record_item_record_link l
	ON rm.id = l.bib_record_id
	AND rm.record_type_code||rm.record_num = 'b4055592'
JOIN sierra_view.item_record_property i
	ON l.item_record_id = i.item_record_id
JOIN sierra_view.circ_trans t
	ON i.item_record_id = t.item_record_id
	AND t.op_code IN ('o','i')
	AND t.transaction_gmt::DATE >= CURRENT_DATE - INTERVAL '1 month'
JOIN sierra_view.varfield v
	ON i.item_record_id = v.record_id
	AND v.varfield_type_code = 'x'
	AND v.field_content ~ '^IMEI'
ORDER BY 1