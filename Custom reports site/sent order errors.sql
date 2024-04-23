/*
Jeremy Goldstein
Minuteman Library Network
Identifies order records that were ftp'd multiple times or not at al but are associated with an edifact enabled vendor
*/

SELECT *,
'' AS "SENT ORDER ERRORS",
'' AS "https://sic.minlib.net/reports/70"
FROM(

SELECT
id2reckey(o.id)||'a' AS order_num,
rm.creation_date_gmt::DATE AS created_date,
o.vendor_record_code AS vendor_code,
STRING_AGG(f.code,', ') AS fund,
STRING_AGG(cmf.location_code,', ') AS location,
STRING_AGG(cmf.copies::VARCHAR,', ') AS copies,
'SENT MULTIPLE TIMES' AS error,
b.best_title AS title

FROM
sierra_view.order_record o
JOIN
sierra_view.subfield sent1
ON
o.id = sent1.record_id AND sent1.field_type_code = 'b' AND sent1.tag = 'b' AND TO_DATE(SUBSTRING(sent1.content, '\d{2}\-\d{2}\-\d{4}'),'MM-DD-YYYY') IS NOT NULL --AND sent1.occ_num = '0'
JOIN
sierra_view.subfield sent2
ON
o.id = sent2.record_id AND sent2.field_type_code = 'b' AND sent2.tag = 'b' AND TO_DATE(SUBSTRING(sent2.content, '\d{2}\-\d{2}\-\d{4}'),'MM-DD-YYYY') IS NOT NULL AND (sent2.varfield_id != sent1.varfield_id OR sent2.display_order != sent1.display_order)
JOIN
sierra_view.record_metadata rm
ON
o.id = rm.id
JOIN
sierra_view.bib_record_order_record_link l
ON
o.id = l.order_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
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
o.accounting_unit_code_num = {{accounting_unit}}

GROUP BY 1,2,3,7,8

UNION

SELECT
id2reckey(o.id)||'a' AS order_num,
rm.creation_date_gmt::DATE AS created_date,
o.vendor_record_code AS vendor_code,
STRING_AGG(f.code,', ') AS fund,
STRING_AGG(cmf.location_code,', ') AS location,
STRING_AGG(cmf.copies::VARCHAR,', ') AS copies,
'NOT SENT' AS error,
b.best_title AS title

FROM
sierra_view.order_record o
LEFT JOIN
sierra_view.varfield sent
ON
o.id = sent.record_id AND sent.varfield_type_code = 'b' AND TO_DATE(SUBSTRING(sent.field_content, '\d{2}\-\d{2}\-\d{4}'),'MM-DD-YYYY') IS NOT NULL AND sent.occ_num = '0'
JOIN
sierra_view.record_metadata rm
ON
o.id = rm.id
JOIN
sierra_view.bib_record_order_record_link l
ON
o.id = l.order_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.vendor_record v
ON
o.vendor_record_code = v.code AND o.accounting_unit_code_num = v.accounting_unit_code_num AND v.vcode3 = 'd'
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
o.accounting_unit_code_num = {{accounting_unit}}
AND sent.id IS NULL
{{#if include}}
AND o.order_status_code IN ('o','q')
{{/if include}}

GROUP BY 1,2,3,7,8
)inner_query

WHERE inner_query.created_date BETWEEN {{start_date}} AND {{end_date}}