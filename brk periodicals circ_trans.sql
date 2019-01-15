--Jeremy Goldstein
--Minuteman Library network

--Framingham circ_trans data limited to library of things materials for Carol Ames

SELECT
c.transaction_gmt,
c.application_name,
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
b.best_title,
v.field_content as volume,
b.material_code,
id2reckey(c.bib_record_id)||'a' as bib_num,
id2reckey(c.item_record_id)||'a' as item_num,
i.barcode,
i.call_number_norm,
c.stat_group_code_num,
c.due_date_gmt,
c.count_type_code_num,
c.itype_code_num,
c.icode1,
c.item_location_code,
c.loanrule_code_num,
md5(CAST(c.patron_record_id AS varchar))

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
c.itype_code_num = '10'
AND
c.item_agency_code_num = '2'

ORDER BY c.transaction_gmt