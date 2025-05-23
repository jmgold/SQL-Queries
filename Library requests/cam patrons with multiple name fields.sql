/*
Jeremy Goldstein
Minuteman Library Network

Cambridge patrons with multiple name fields
*/

/*
WITH
multi_name AS (
*/
SELECT
rm.record_type_code||rm.record_num||'a' AS pnumber --p.id

FROM
sierra_view.patron_record p
JOIN
sierra_view.patron_record_fullname n
ON
p.id = n.patron_record_id AND p.ptype_code = '7'
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id AND rm.creation_date_gmt >= '2024-04-22'

GROUP BY 1
HAVING COUNT(n.id) >1
/*
)

SELECT
rm.record_type_code||rm.record_num||'a' AS pnumber,
n.last_name||' '||n.first_name||' '||n.middle_name

FROM multi_name nx
JOIN
sierra_view.record_metadata rm
ON
nx.id = rm.id
JOIN
sierra_view.patron_record_fullname n
ON
nx.id = n.patron_record_id
*/