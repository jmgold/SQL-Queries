/*
Jeremy Goldstein
Minuteman Library Network

use to gather Items where a library owns multiple circulating copies of a title.

Passed variables for owning location, item statuses to exclude, mat types, copies greater than x and records created before
*/
WITH bib_list AS(
SELECT 
l.bib_record_id,
COUNT(i.id)
FROM 
sierra_view.bib_record b
JOIN
sierra_view.bib_record_item_record_link AS l
ON
b.id = l.bib_record_id
JOIN
sierra_view.item_record as i
ON
i.id = l.item_record_id
--AND i.icode1 IN ('1','2') 
AND i.location_code ~ '{{location}}'
AND i.item_status_code NOT IN ({{item_status_codes}})
JOIN
sierra_view.record_metadata m
ON
i.id = m.id AND m.creation_date_gmt < {{created_date}}

WHERE
b.bcode1 = 'm' 
AND b.bcode2 IN ({{mat_type}}) 
group by 1
having count(i.id) > {{copies}}
)

SELECT
ID2RECKEY(b.bib_record_id)||'a' AS bib_number,
b.best_title AS title,
b.best_author AS author,
id2reckey(ip.item_record_id)||'a' AS item_number,
ip.barcode,
i.location_code,
REPLACE(ip.call_number,'|a','') AS call_number,
i.checkout_total,
i.last_checkout_gmt::DATE AS last_checkout,
rm.creation_date_gmt::DATE AS creation_date,
CASE
	WHEN C.id IS NOT NULL THEN 'CHECKED OUT'
	ELSE status.name
END AS status,
COALESCE(TO_CHAR(C.due_gmt, 'YYYY-mm-dd'),'') AS due_date

FROM
bib_list bl
JOIN
sierra_view.bib_record_property b
ON
bl.bib_record_id = b.bib_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record_property ip
ON
l.item_record_id = ip.item_record_id
JOIN
sierra_view.item_record i
ON
ip.item_record_id = i.id
AND i.location_code ~ '{{location}}'
AND i.item_status_code NOT IN ({{item_status_codes}})
LEFT JOIN
sierra_view.checkout C
ON
i.id = C.item_record_id
JOIN
sierra_view.item_status_property_myuser status
ON
i.item_status_code = status.code
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id AND rm.creation_date_gmt < {{created_date}}

ORDER BY 1,6,7