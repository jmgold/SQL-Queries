--Jeremy Goldstein
--Minuteman Library Network

--Provides item counts by language and location
--Used to produce chart in Tableau

SELECT
n.name AS language,
loc.name AS Location,
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
SUBSTRING(i.location_code FROM 1 FOR 3) = loc.code::varchar
GROUP BY 1,2
ORDER BY
1,2