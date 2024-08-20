/*
Jeremy Goldstein
Minuteman Library Network
Find patron records with multiple barcode fields, sorted by the number of barcodes present in each record
*/
SELECT 
rm.record_type_code||rm.record_num||'a' as record_number,
COUNT(v.id)
FROM
sierra_view.patron_record AS p
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id
JOIN
sierra_view.varfield AS v
ON
p.id = v.record_id AND v.varfield_type_code = 'b'

GROUP BY 1
HAVING COUNT(v.id) > 1
ORDER BY 2 DESC
