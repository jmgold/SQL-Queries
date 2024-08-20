/*
request from Stow to look at holds made by Stow patrons who may not have
changed their pickup location back to Stow after they reopened
*/

SELECT
mat.name AS mat_type,
rm.record_type_code||rm.record_num||'a' AS record_number,
b.best_title,
b.best_author,
COUNT(DISTINCT h.id) AS total_holds,
COUNT(DISTINCT h.id) FILTER(WHERE h.pickup_location_code = 'stoz') total_stow_pickup,
COUNT(DISTINCT h.id) FILTER(WHERE h.pickup_location_code != 'stoz') AS total_pickup_elsewhere

FROM
sierra_view.hold h
JOIN
sierra_view.patron_record p
ON
h.patron_record_id = p.id AND p.ptype_code IN ('32','332')
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.bib_record_id OR h.record_id = l.bib_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id
JOIN
sierra_view.material_property_myuser mat
ON
b.material_code = mat.code

GROUP BY 1,2,3,4
ORDER BY 1, 5 desc