SELECT
n.name AS language,
loc.name AS location,
M.name AS format,
COUNT(i.id) AS total_items
FROM
sierra_view.bib_record b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND SUBSTRING(i.location_code FROM 1 FOR 3) NOT IN ('','int','hpl','knp')
JOIN
sierra_view.language_property_myuser n
ON
b.language_code = n.code
JOIN
sierra_view.location_myuser loc
ON
SUBSTRING(i.location_code FROM 1 FOR 3) = loc.code::VARCHAR
JOIN
sierra_view.material_property_myuser M
ON
b.bcode2 = M.code
GROUP BY 1,2,3
ORDER BY
1,2