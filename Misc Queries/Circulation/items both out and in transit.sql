/*
Jeremy Goldstein
Minuteman Library Network

Identify items that are simultaneously checked out and in transit.
Caused by a self check session being left open when a patron immediately returns an unwanted item
*/
SELECT
rm.record_type_code||rm.record_num||'a' AS record_num,
o.checkout_gmt,
i.*
FROM
sierra_view.item_record i
JOIN
sierra_view.checkout o
ON
i.id = o.item_record_id
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id
WHERE i.item_status_code = 't'