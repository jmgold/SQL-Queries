/*
Jeremy Goldstein
Minuteman Library Network

Find locked order records
*/
SELECT
m.record_type_code||m.record_num||'a',
m.record_last_updated_gmt,
o.accounting_unit_code_num

FROM
sierra_view.record_lock r
JOIN
sierra_view.record_metadata m
ON
m.id = r.id
JOIN
sierra_view.order_record o
ON
m.id = o.id

--omit records that are likely locked from being in a payment session
WHERE
NOT EXISTS (
SELECT 
i.order_record_metadata_id
FROM
sierra_view.invoice_record_line i
WHERE i.order_record_metadata_id = o.id
)


ORDER BY 2