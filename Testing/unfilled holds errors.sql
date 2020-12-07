SELECT
*

FROM
sierra_view.hold h
JOIN
sierra_view.checkout o
ON
h.record_id = o.item_record_id AND h.patron_record_id = o.patron_record_id 
AND h.status IN ('b','i') AND o.checkout_gmt::DATE > '2020-11-18'
JOIN
sierra_view.circ_trans t
ON
o.item_record_id = t.item_record_id AND o.patron_record_id = t.patron_record_id 
AND t.op_code = 'o' AND t.transaction_gmt > '2020-11-18' 
AND t.stat_group_code_num IN ('380','400','408','440','490','500','530','538','580','588','748','800')