/*
Jeremy Goldstein
Minuteman Library Network

Identifies bibs where a library owns multiple items that have different call numbers
*/

WITH inner_query AS
(
SELECT
b.bib_record_id,
b.best_title,
COUNT(*) AS item_count,
COUNT(DISTINCT ip.call_number_norm) AS unique_count

FROM
sierra_view.item_record i
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id AND b.material_code IN ({{mat_type}})
{{#if Exclude}}
LEFT JOIN
sierra_view.subfield v
ON
i.id = v.record_id AND v.field_type_code = 'v'
{{/if Exclude}}

WHERE
i.location_code ~ {{location}}
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
AND i.item_status_code NOT IN ({{item_status_codes}})
AND {{age_level}}
	/*
	SUBSTRING(i.location_code,4,1) NOT IN ('y','j') --adult
	SUBSTRING(i.location_code,4,1) = 'j' --juv
	SUBSTRING(i.location_code,4,1) = 'y' --ya
	i.location_code ~ '\w' --all
	*/
	
GROUP BY 1,2
{{#if Exclude}}
--use to weed out items with volume fields, which in some cases may throw off results
HAVING
COUNT(v.*) = 0 
{{/if Exclude}}

)

SELECT
id2reckey(inner_query.bib_record_id)||'a' AS bib_number,
inner_query.best_title,
inner_query.item_count,
STRING_AGG(DISTINCT TRIM(REPLACE(ip.call_number,'|a','')),'| ') AS call_numbers

FROM
sierra_view.bib_record_item_record_link l
JOIN
inner_query
ON
l.bib_record_id = inner_query.bib_record_id AND inner_query.unique_count > 1
JOIN
item_record i
ON
l.item_record_id = i.id AND i.location_code ~ {{location}}
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
AND i.item_status_code NOT IN ({{item_status_codes}})
AND {{age_level}}
	/*
	SUBSTRING(i.location_code,4,1) NOT IN ('y','j') --adult
	SUBSTRING(i.location_code,4,1) = 'j' --juv
	SUBSTRING(i.location_code,4,1) = 'y' --ya
	i.location_code ~ '\w' --all
	*/
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id


GROUP BY 1,2,3