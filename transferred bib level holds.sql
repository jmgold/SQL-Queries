/*
Jeremy Goldstein
Minuteman Library Network
identifies recent bib holds that may have been
transferred between records since being placed
*/

SELECT
id2reckey(h.record_id)||'a',
id2reckey(t.bib_record_id)||'a',
*
FROM
sierra_view.hold h
JOIN
sierra_view.circ_trans t
ON
h.patron_record_id = t.patron_record_id AND h.placed_gmt = t.transaction_gmt AND t.op_code = 'nb' AND h.status = '0'
AND h.record_id != t.bib_record_id
