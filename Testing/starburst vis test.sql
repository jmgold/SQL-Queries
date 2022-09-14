SELECT
loc.name AS location,
mat.name AS mattype,
it.name AS itype,
COUNT(i.id) AS total
FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.material_property_myuser mat
ON
b.material_code = mat.code
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code
JOIN
sierra_view.location_myuser loc
ON
SUBSTRING(i.location_code,1,3) = loc.code
GROUP BY 1,2,3
ORDER BY 1,2,3