/*
Jeremy Goldstein
Minuteman Library Network
based on query by David Jones and shared over Sierra listserv 9/20/16
Finds patron records that share a barcode
*/

SELECT
rm.record_type_code||rm.record_num||'a' AS pnumber,
p.index_entry AS barcode,
rm.creation_date_gmt AS creation_date,
pt.name AS ptype

FROM
sierra_view.phrase_entry AS p
JOIN
sierra_view.patron_record AS pr
ON
p.record_id = pr.record_id AND p.index_tag = 'b'
JOIN
sierra_view.record_metadata rm
ON
pr.id = rm.id
JOIN
sierra_view.ptype_property_myuser pt
ON
pr.ptype_code = pt.value

WHERE
--optional limit to a ptype
pr.ptype_code = '7' AND
p.index_entry IN (

SELECT
p.index_entry

FROM
sierra_view.phrase_entry as p
WHERE
p.index_tag = 'b' 
--limit to 14 digit numbers to limit results further to actual barcodes
AND p.index_entry ~ '\d{14}'
GROUP BY
p.index_entry
HAVING
COUNT(p.id) > 1)
ORDER BY
p.index_entry, rm.record_num
