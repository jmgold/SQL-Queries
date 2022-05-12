/*
Jeremy Goldstein
Minuteman Library Network
Adapted from query shared by Jim Nicholls on Sierra list 3/24/17
Checks for items that do not exist in the item_record_property table
*/
SELECT 
i.record_id
,rm.record_type_code||rm.record_num||'a' AS item_number
,rm.num_revisions
,rm.creation_date_gmt
,rm.record_last_updated_gmt
,rm.previous_last_updated_gmt

FROM
sierra_view.item_record i
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id
LEFT JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id

WHERE rm.deletion_date_gmt IS NULL
AND ip.id IS NULL