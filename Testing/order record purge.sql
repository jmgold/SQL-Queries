SELECT
o.order_status_code AS status,
rm.creation_date_gmt::DATE AS created_date,
o.order_type_code AS order_type,
o.received_date_gmt::DATE AS received_date,
id2reckey(o.id)||'a' AS record_number,
--STRING_AGG(cmf.fund_code,', ') AS "fund",
--STRING_AGG(cmf.location_code, ', ') AS "location",
o.estimated_price::MONEY AS est_price,
--STRING_AGG(cmf.copies::VARCHAR, ', ') AS copies,
o.vendor_record_code AS vendor,
COALESCE(po.field_content,'') AS po,
COALESCE(init.field_content,'') AS staff_initials,
b.best_title AS title

FROM
sierra_view.order_record o
JOIN
sierra_view.order_record_cmf cmf
ON
o.id = cmf.order_record_id
JOIN
sierra_view.accounting_unit a
ON
o.accounting_unit_code_num = a.code_num
JOIN
sierra_view.fund_master fm
ON
fm.code_num = cmf.fund_code::INT AND fm.accounting_unit_id = a.id
LEFT JOIN
sierra_view.order_record_paid p
ON
o.id = p.order_record_id
JOIN
sierra_view.record_metadata rm
ON
o.id = rm.id
LEFT JOIN
sierra_view.varfield po
ON
o.id = po.record_id AND po.varfield_type_code = 'p'
LEFT JOIN
sierra_view.varfield init
ON
o.id = po.record_id AND po.varfield_type_code = 'j'
JOIN
sierra_view.bib_record_order_record_link l
ON
o.id = l.order_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id

WHERE
--plug in accounting unit code
o.accounting_unit_code_num = '4' AND 
(rm.creation_date_gmt::DATE < '2018-07-01' AND o.order_status_code = 'z')
OR (o.order_status_code = 'a' AND p.paid_date_gmt::DATE < '2018-07-01')

--GROUP BY 1,2,3,4,5,8,10,11,12,13
ORDER BY 2

LIMIT 100