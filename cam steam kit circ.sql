--Jeremy Goldstein
--Minuteman Library network

--Cambridge circ_trans data stripped of patron info for project run by Reinhard Engels

SELECT
DISTINCT i.barcode,
i.call_number_norm,
b.best_title,
c.item_location_code,
COUNT (c.id) as total_checkouts,
COUNT (DISTINCT c.patron_record_id) AS unique_patron_count,
/*CASE
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
*/
id2reckey(c.bib_record_id)||'a' as bib_num,
id2reckey(c.item_record_id)||'a' as item_num,
c.stat_group_code_num

FROM
sierra_view.circ_trans c
JOIN
sierra_view.bib_record_property b
ON
--Limited to equipment
c.bib_record_id = b.bib_record_id AND b.material_code IN ('q','r','v')
JOIN
sierra_view.item_record_property i
ON
c.item_record_id = i.item_record_id
WHERE
item_agency_code_num = 3 AND c.op_code = 'o' --AND c.itype_code_num = '252' AND c.icode1 = '186'
AND c.transaction_gmt > (localtimestamp - interval '1 week')
GROUP BY
1,2,3,4,7,8,9
ORDER BY 
3,2