/*
Jeremy Goldstein
Minuteman Library Network

Identifies patrons with repeated varfields. 
Created to trace down a problem where a system glitch would lead to fields being copied in certain circumstances.
*/

SELECT
rm.record_type_code||rm.record_num||'a' AS record_num,
v.varfield_type_code,
COUNT(v.*)
FROM
sierra_view.varfield v
JOIN
sierra_view.record_metadata rm
ON
v.record_id = rm.id AND rm.record_type_code = 'p'

GROUP BY 1,2
HAVING COUNT(v.*) > 1
ORDER BY 1,2