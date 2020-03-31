/*
Jeremy Goldstein
Minuteman Library Network

Rough approximation of paging list, looking for holds at a pickkup location that can be filled by
currently available items at that location
*/

WITH available_copies AS(
SELECT
l.bib_record_id,
i.itype_code_num,
i.location_code,
i.id,
ROW_NUMBER() OVER (PARTITION BY l.bib_record_id) AS "copy"
FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id

WHERE i.location_code ~ '^nat' AND i.is_available_at_library = 'true' AND i.item_status_code = '-'
)


SELECT 
DISTINCT h.id AS Hold_Id,
id2reckey(l.bib_record_id)||'a' AS "Bib Number",
i.barcode AS Barcode,
REPLACE(REPLACE(i.call_number,'|a',''),'|f','') AS "Call Number",
b.best_author AS Author,
b.best_title AS Title,
pickup_loc.name AS "Pickup Location",
loc.name AS "Item Location",
copies.itype_code_num AS Itype

FROM
sierra_view.hold h
JOIN
(
SELECT
h.id,
h.record_id,
ROW_NUMBER() OVER (PARTITION BY h.record_id ORDER BY h.placed_gmt) AS "hold_num"
FROM
sierra_view.hold h
WHERE h.pickup_location_code ~ '^nat'
)hold_num
ON
h.id = hold_num.id
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.bib_record_id --OR h.record_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
available_copies copies
ON
l.bib_record_id = copies.bib_record_id AND hold_num.hold_num = copies.copy
JOIN
sierra_view.item_record_property i
ON
copies.id = i.item_record_id
JOIN
sierra_view.location_myuser loc
ON
copies.location_code = loc.code
JOIN
sierra_view.location_myuser pickup_loc
ON
SUBSTRING(h.pickup_location_code,1,3) = pickup_loc.code

WHERE
h.pickup_location_code ~ '^nat'
AND h.is_frozen = 'false' AND (h.placed_gmt::DATE + h.delay_days) < NOW()::DATE

UNION

SELECT 
DISTINCT h.id AS Hold_Id,
id2reckey(l.bib_record_id)||'a' AS "Bib Number",
i.barcode AS Barcode,
REPLACE(REPLACE(i.call_number,'|a',''),'|f','')||' '||v.field_content AS "Call Number",
b.best_author AS Author,
b.best_title AS Title,
pickup_loc.name AS "Pickup Location",
loc.name AS "Item Location",
ir.itype_code_num AS Itype

FROM
sierra_view.hold h
JOIN
(
SELECT
h.id,
h.record_id,
ROW_NUMBER() OVER (PARTITION BY h.record_id ORDER BY h.placed_gmt) AS "hold_num"
FROM
sierra_view.hold h
WHERE h.pickup_location_code ~ '^nat'
)hold_num
ON
h.id = hold_num.id
JOIN
sierra_view.item_record ir
ON
h.id = ir.id AND ir.location_code ~ '^nat' AND ir.is_available_at_library = 'true' AND ir.item_status_code = '-'
JOIN
sierra_view.bib_record_item_record_link l
ON
--h.record_id = l.bib_record_id OR 
ir.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.item_record_property i
ON
ir.id = i.item_record_id
JOIN
sierra_view.varfield v
ON
i.item_record_id = v.record_id AND v.varfield_type_code = 'v'
JOIN
sierra_view.location_myuser loc
ON
ir.location_code = loc.code
JOIN
sierra_view.location_myuser pickup_loc
ON
SUBSTRING(h.pickup_location_code,1,3) = pickup_loc.code

WHERE
h.pickup_location_code ~ '^nat'
AND h.is_frozen = 'false' AND (h.placed_gmt::DATE + h.delay_days) < NOW()::DATE

ORDER BY 2,1
