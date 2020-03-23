--to try

--for each bib record assign a number to each hold on that record
--and then do the same for available items and join those two together on the copy values

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

WHERE i.location_code ~ '^nor' AND i.is_available_at_library = 'true'
)


SELECT DISTINCT ON (h.id,l.bib_record_id,copies.copy)
h.id AS Hold_Id,
id2reckey(l.bib_record_id)||'a' AS "Bib Number",
i.barcode AS Barcode,
i.call_number_norm AS "Call Number",
b.best_author AS Author,
b.best_title AS Title,
h.pickup_location_code AS "Pickup Location",
copies.location_code AS "Item Location",
copies.itype_code_num AS Itype,
copies.copy,
l.bib_record_id

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
available_copies copies
ON
l.bib_record_id = copies.bib_record_id
JOIN
sierra_view.item_record_property i
ON
copies.id = i.item_record_id

WHERE
h.pickup_location_code ~ '^nor'
AND h.is_frozen = 'false'

--GROUP BY 1,3,4,5,6,7,8,9
ORDER BY 1,11,10
