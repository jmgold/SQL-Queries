/*
Jeremy Goldstein
Minuteman Library Network

use to gather bibs where a library owns multiple circulating copies of a title.
and recent circ suggests that some copies could be weeded

Passed variables for owning location, item statuses to exclude, copies greater than x and turnover less than y
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
AND i.icode1 IN ('1','2') 
AND i.location_code ~ '^lex'
JOIN
sierra_view.record_metadata m
ON
i.id = m.id --AND m.creation_date_gmt < {{created_date}}

WHERE
b.bcode1 = 'm' 
AND b.bcode2 IN ('a') 
group by 1
having count(i.id) > 2
)

SELECT
ID2RECKEY(b.bib_record_id)||'a' AS bib_number,
b.best_title AS title,
b.best_author AS author,
id2reckey(ip.item_record_id)||'a' AS item_number,
ip.barcode,
i.location_code,
REPLACE(ip.call_number,'|a','') AS call_number,
CASE
	WHEN C.id IS NOT NULL THEN 'CHECKED OUT'
	ELSE status.name
END AS status,
COALESCE(TO_CHAR(C.due_gmt, 'Mon DD YYYY'),'') AS due_date

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
ip.item_record_id = i.id AND i.location_code ~ '^lex'
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id AND rm.creation_date_gmt::DATE < '2020-01-01'
LEFT JOIN
sierra_view.checkout C
ON
i.id = C.item_record_id
JOIN
sierra_view.item_status_property_myuser status
ON
i.item_status_code = status.code

ORDER BY 1,6,7
