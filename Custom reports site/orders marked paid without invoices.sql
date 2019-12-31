/*
Jeremy Goldstein
Minuteman Library Network

Identifies order records that have been marked paid but were not invoiced
*/

SELECT
id2reckey(o.id)||'a' order_record_number,
o.order_date_gmt::DATE AS order_date,
STRING_AGG(fm.code, ', ') AS fund,
STRING_AGG(cmf.location_code, ', ') AS location,
o.vendor_record_code AS vendor,
cmf.copies,
o.estimated_price::MONEY,
b.best_title AS title

FROM
sierra_view.order_record o
JOIN
sierra_view.order_record_cmf cmf
ON
o.id = cmf.order_record_id
JOIN
sierra_view.accounting_unit_myuser a
ON
o.accounting_unit_code_num = a.code
JOIN
sierra_view.accounting_unit au
ON
o.accounting_unit_code_num = au.code_num
JOIN
sierra_view.fund_master fm
ON
cmf.fund_code::INT = fm.code_num AND au.id = fm.accounting_unit_id
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

WHERE o.order_status_code IN ('a','q')
AND p.id IS NULL
AND o.accounting_unit_code_num = {{accounting_unit}}

GROUP BY 1,o.order_date_gmt,5,6,7,8


ORDER BY o.order_date_gmt