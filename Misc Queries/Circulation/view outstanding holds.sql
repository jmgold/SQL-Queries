/*
Jeremy Goldstein
Minuteman Library Network
Reproduces View Outstanding Holds Report
*/

SELECT
h.placed_gmt::DATE AS "Date Placed",
h.expires_gmt::DATE AS "Not Needed After",
n.last_name||', '||n.first_name||' '||n.middle_name AS "Patron Name",
REPLACE(i.call_number,'|a','') AS "CALL NO.",
ir.location_code AS "Location",
CASE
	WHEN h.status = 't' THEN 'IN TRANSIT'
	WHEN h.status IN ('b','i') THEN 'ON HOLDSHELF'
	ELSE 'OUTSTANDING'
END AS "Status",
COALESCE(h.expire_holdshelf_gmt::DATE::VARCHAR,'') AS "Expires From Holdshelf"

FROM
sierra_view.hold h
JOIN
sierra_view.patron_record_fullname n
ON
h.patron_record_id = n.patron_record_id
LEFT JOIN
sierra_view.item_record_property i
ON
h.record_id = i.item_record_id
JOIN
sierra_view.item_record ir
ON
h.record_id = ir.id
WHERE
h.pickup_location_code = 'neez'
--AND h.status IN ('b','i')
ORDER BY 6,1