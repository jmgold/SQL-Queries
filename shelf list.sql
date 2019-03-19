--Jeremy Goldstein
--Minuteman Library Network

--Shelf list generator

SELECT
REPLACE(ip.call_number,'|a',''),
ip.barcode,
CASE
	WHEN i.item_status_code = '-' AND c.id IS NOT NULL THEN 'CHECKED OUT'
	ELSE s.name
END AS status,
b.best_title
FROM
sierra_view.item_record_property ip
JOIN
sierra_view.item_record i
ON
ip.item_record_id = i.id 
--Limit to a given location
AND i.location_code LIKE 'las%'
JOIN
sierra_view.bib_record_item_record_link bi
ON
i.id = bi.item_record_id
JOIN
sierra_view.bib_record_property b
ON
bi.bib_record_id = b.bib_record_id 
--Exclude electronic materials
AND b.material_code NOT IN ('h','l','m','s','w','y')
JOIN
sierra_view.item_status_property_myuser s
ON
i.item_status_code = s.code
LEFT JOIN
sierra_view.checkout c
ON
i.id = c.item_record_id
--Optional filter to limit call number range
--WHERE ip.call_number_norm BETWEEN '000' AND '100'
ORDER BY ip.call_number_norm