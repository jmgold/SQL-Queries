/*
Jeremy Goldstein
Minuteman Library Network
Patrons with multiple holds on the same bib record
*/
SELECT
rmp.record_type_code||rmp.record_num||'a' AS pnumber,
rmb.record_type_code||rmb.record_num||'a' AS bnumber,
COUNT(DISTINCT h.id)
FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.item_record_id OR h.record_id = l.bib_record_id
JOIN
sierra_view.record_metadata rmp
ON
h.patron_record_id = rmp.id
JOIN
sierra_view.record_metadata rmb
ON
l.bib_record_id = rmb.id

GROUP BY 1,2
HAVING
COUNT(DISTINCT h.id) >1