--Jeremy Goldstein
--Minuteman Library Network

--Identifies all payments made in a given fiscal year for a particular fund

SELECT *,
id2reckey(p.order_record_id)
FROM
sierra_view.order_record_paid p
JOIN
sierra_view.order_record_cmf o
ON
--Select Location code
p.order_record_id = o.order_record_id AND o.location_code LIKE 'ntn%'
JOIN
sierra_view.fund_master f
ON
--Select Fund code
o.fund_code::int = f.code_num AND f.code = 'jvav'
WHERE
p.invoice_date_gmt::DATE >= '2018-07-01' 
ORDER BY p.paid_date_gmt