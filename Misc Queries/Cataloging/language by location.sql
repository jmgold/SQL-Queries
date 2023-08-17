/*
Jeremy Goldstein
Minuteman Library Network

Provides counts of items in a language
subdivided by location and format
*/

WITH language_limit AS (
SELECT
b.language_code,
COUNT(i.id) AS item_count
FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record b
ON
l.bib_record_id = b.id

WHERE b.language_code != 'eng'

GROUP BY 1
HAVING COUNT(i.id) >= 100
)

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
JOIN language_limit ll
ON
b.language_code = ll.language_code
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