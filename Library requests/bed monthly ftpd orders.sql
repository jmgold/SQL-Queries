SELECT
o.vendor_record_code AS vendor_code,
COUNT(DISTINCT o.id) AS total_records,
SUM(cmf.copies) AS total_copies

FROM
sierra_view.order_record o
JOIN
sierra_view.subfield sent
ON
o.id = sent.record_id AND sent.field_type_code = 'b' AND sent.tag = 'b' AND TO_DATE(SUBSTRING(sent.content, '\d{2}\-\d{2}\-\d{4}'),'MM-DD-YYYY') IS NOT NULL
JOIN sierra_view.order_record_cmf cmf
ON
o.id = cmf.order_record_id AND cmf.location_code != 'multi'
JOIN
sierra_view.accounting_unit a
ON
o.accounting_unit_code_num = a.code_num
JOIN
sierra_view.fund_master f
ON
cmf.fund_code::INT = f.code_num AND a.id = f.accounting_unit_id

WHERE
o.accounting_unit_code_num = 4
AND TO_DATE(SUBSTRING(sent.content, '\d{2}\-\d{2}\-\d{4}'),'MM-DD-YYYY') >= CURRENT_DATE - INTERVAL '1 month'

GROUP BY 1