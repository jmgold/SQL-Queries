/*
Jeremy Goldstein
Minuteman Library Network

Use to identify order records to be deleted annually
Each August we clear out orders that were completed more than two full fiscal years ago
Change up date limit in lines 88 and 89
*/

SELECT
rm.record_type_code||rm.record_num||'a' AS "RECORD #",
o.accounting_unit_code_num AS "ACCOUNTING UNIT",
rm.creation_date_gmt::DATE AS "CREATED",
o.acq_type_code AS "ORD TYPE",
o.received_date_gmt::DATE AS "RDATE",
STRING_AGG(fm.code,',') AS "FUND",
STRING_AGG(cmf.location_code,',') AS "LOCATION",
o.estimated_price::MONEY AS "E PRICE",
SUM(cmf.copies) AS "COPIES",
o.vendor_record_code AS "VENDOR",
COALESCE(po.field_content,'') AS "LOCAL PO #",
COALESCE(init.field_content,'') AS "INITIALS",
b.best_title AS "TITLE",
STRING_AGG(isbn.field_content,', ') AS "ISBN PICK",
COALESCE(note.field_content,'') AS "NOTE",
COALESCE(innote.field_content,'') AS "INT NOTE",
p.paid_date_gmt::DATE AS "PAID DATE",
p.invoice_date_gmt::DATE AS "INVOICE DATE",
COALESCE(p.invoice_code,'') AS "INVOICE NUM",
COALESCE(p.paid_amount::MONEY,'') AS "AMOUNT PAID",
COALESCE(p.voucher_num::VARCHAR,'') AS "VOUCHER NUM",
COALESCE(p.copies::VARCHAR,'') AS "COPIES",
p.from_date_gmt::DATE AS "SUB FROM",
p.to_date_gmt::DATE AS "SUB TO",
COALESCE(p.note,'') AS "NOTE"

FROM
sierra_view.order_record o
JOIN
sierra_view.record_metadata rm
ON
o.id = rm.id
JOIN
sierra_view.order_record_cmf cmf
ON
o.id = cmf.order_record_id
LEFT JOIN
sierra_view.order_record_paid p
ON
o.id = p.order_record_id
JOIN
sierra_view.bib_record_order_record_link l
ON
o.id = l.order_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.accounting_unit a
ON
o.accounting_unit_code_num = a.code_num
JOIN
sierra_view.fund_master fm
ON
fm.code_num = cmf.fund_code::INT AND fm.accounting_unit_id = a.id
LEFT JOIN
sierra_view.varfield po
ON
o.id = po.record_id AND po.varfield_type_code = 'y'
LEFT JOIN
sierra_view.varfield init
ON
o.id = init.record_id AND init.varfield_type_code = 'j'
LEFT JOIN
sierra_view.varfield isbn
ON
o.id = isbn.record_id AND isbn.varfield_type_code = 'b'
LEFT JOIN
sierra_view.varfield note
ON
o.id = note.record_id AND note.varfield_type_code = 'n'
LEFT JOIN
sierra_view.varfield innote
ON
o.id = innote.record_id AND innote.varfield_type_code = 'z'

WHERE (o.order_status_code = 'a' AND p.paid_date_gmt::DATE < '07-01-20')
OR (o.order_status_code = 'z' AND rm.creation_date_gmt::DATE < '07-01-20')
AND o.order_status_code IN ('a','z')

GROUP BY 1,2,3,4,5,8,10,11,12,13,15,16,17,18,19,20,21,22,23,24,25
ORDER BY 2,3