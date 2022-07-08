/*
Jeremy Goldstein
Minuteman Library network

Identify checkout transactions that were improperly recorded
bug seems to be tied to mobile self checkouts that get double entered in circ_trans
then produce bad data in the checkout table, most easily identified as having a due date of 12/31/1969
*/
SELECT
rmi.record_type_code||rmi.record_num||'a' AS item_number,
rmi.record_last_updated_gmt,
rmp.record_type_code||rmp.record_num||'a' AS patron_number,
o.*
FROM
sierra_view./*circ_trans o --*/checkout o
JOIN
sierra_view.record_metadata rmi
ON
o.item_record_id = rmi.id
JOIN
sierra_view.record_metadata rmp
ON
o.patron_record_id = rmp.id
WHERE
o.due_gmt <= '1970-01-01' --for checkout
--o.due_date_gmt <= '1970-01-01' AND o.op_code = 'o'--for circ_trans
--o.item_record_id = '450983890025'
--o.patron_record_id = '481037837692'