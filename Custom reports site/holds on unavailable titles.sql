/*
Jeremy Goldstein
Minuteman Library Network
Identifies holds placed on unavailble items or titles

Modified from a query originally shared by Brent Searle
*/

SELECT
rmb.record_type_code||rmb.record_num||'a' AS bib_number,
b.best_title AS title,
m.name AS mat_type,
rmp.record_type_code||rmp.record_num||'a' AS patron_number,
CASE
	WHEN rmh.record_type_code = 'i' THEN 'Item'
	ELSE 'Bib'
END AS hold_type,
h.placed_gmt::DATE AS date_placed,
CASE
	WHEN h.is_frozen = TRUE THEN 'True'
	ELSE 'False'
END AS is_frozen,
h.expires_gmt::DATE AS expiration_date

FROM
sierra_view.hold h 
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.bib_record_id OR h.record_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.record_metadata rmb
ON
b.bib_record_id = rmb.id
JOIN
sierra_view.material_property_myuser m
ON
b.material_code = m.code
JOIN
sierra_view.record_metadata rmp
ON
h.patron_record_id = rmp.id
JOIN
sierra_view.record_metadata rmh
ON
h.record_id = rmh.id

WHERE h.pickup_location_code ~ '{{location}}' 
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
AND b.bib_record_id NOT IN
--subquery bibs with available copies and holds
(
SELECT DISTINCT l.bib_record_id

FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.bib_record_id OR h.record_id = l.item_record_id
JOIN
sierra_view.item_record i
ON l.item_record_id = i.id 

GROUP BY l.bib_record_id
HAVING COUNT(DISTINCT i.id) FILTER(WHERE i.item_status_code NOT IN ('$','e','m','n','o','w','z')) > 0
)

GROUP BY 1,2,3,4,5,6,7,8,b.best_title_norm
ORDER BY b.best_title_norm