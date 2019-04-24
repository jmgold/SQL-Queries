--Jeremy Goldstein
--Minuteman Library network

--Brookline circ_trans data limited to periodicals materials for Isaac Ball

SELECT
b.best_title,
CASE
WHEN c.op_code = 'o' THEN 'checkout'
WHEN c.op_code = 'i' THEN 'checkin'
WHEN c.op_code = 'n' THEN 'hold'
WHEN c.op_code = 'h' THEN 'hold with recall'
WHEN c.op_code = 'nb' THEN 'bib hold'
WHEN c.op_code = 'hb' THEN 'hold recall bib'
WHEN c.op_code = 'ni' THEN 'item hold'
WHEN c.op_code = 'hi' THEN 'hold recall item'
WHEN c.op_code = 'nv' THEN 'volume hold'
WHEN c.op_code = 'hv' THEN 'hold recall volume'
WHEN c.op_code = 'f' THEN 'filled hold'
WHEN c.op_code = 'r' THEN 'renewal'
WHEN c.op_code = 'b' THEN 'booking'
WHEN c.op_code = 'u' THEN 'use count'
ELSE 'unknown'
END AS transaction_type,
c.transaction_gmt,
v.field_content as volume,
i.barcode,
c.item_location_code

FROM
sierra_view.circ_trans c
JOIN
sierra_view.bib_record_property b
ON
c.bib_record_id = b.bib_record_id
JOIN
sierra_view.item_record_property i
ON
c.item_record_id = i.item_record_id
JOIN
sierra_view.varfield v
ON
i.item_record_id = v.record_id AND v.varfield_type_code = 'v'

WHERE
c.itype_code_num IN ('10','107','158')
AND
SUBSTRING(c.item_location_code FROM 1 FOR 3) = 'brk'

ORDER BY c.transaction_gmt