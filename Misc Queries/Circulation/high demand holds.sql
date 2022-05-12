/*
Jeremy Goldstein
Minuteman Library Network
Reproduces Sierra High Demand Holds report for a given pickup location
*/
SELECT
b.best_title AS title
,b.best_author AS author
,mat.name AS material_type
,COUNT(DISTINCT h.id) AS system_holds
,COUNT(DISTINCT i.id) AS system_items
--set the location code to filter on in the following two lines
,COUNT(DISTINCT h.id) FILTER(WHERE h.pickup_location_code ~ 'act') AS local_holds
,COUNT(DISTINCT i.id) FILTER(WHERE i.location_code ~ 'act') AS local_items

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
sierra_view.material_property_myuser mat
ON
b.material_code = mat.code
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id

GROUP BY 1,2,3,b.best_title_norm
ORDER BY b.best_title_norm
