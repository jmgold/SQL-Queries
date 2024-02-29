/*
Jeremy Goldstein
Minuteman Library Network
Gathers up record list for all bibs and items on reserve and the courses they are associated with
*/

SELECT
*,
'' AS "COURSE RESERVES AUDIT",
'' AS "https://sic.minlib.net/reports/113"
FROM
(--Gather up course information for bibs on reserve
SELECT
rm.record_type_code||rm.record_num||'a' AS course_number,
STRING_AGG(course.field_content,', ' ORDER BY course.occ_num) AS course,
prof.field_content AS professor,
cr.begin_date::DATE AS start_date,
cr.end_date::DATE AS end_date,
rmb.record_type_code||rmb.record_num||'a' AS record_number,
CASE
	WHEN cbl.status_code = 'a' THEN 'active/bib'
	ELSE 'inactive/bib'
END AS reserve_status,
cbl.status_change_date::DATE AS status_change_date,
b.best_title AS title,
b.best_author AS author,
--Needed to match data with item's in second part of query
'N/A' AS itype,
'N/A' AS item_status,
'N/A' AS call_number,
'N/A' AS item_location

FROM
sierra_view.course_record cr
LEFT JOIN
sierra_view.course_record_bib_record_link cbl
ON
cr.id = cbl.course_record_id
JOIN
sierra_view.bib_record_property b
ON
cbl.bib_record_id = b.bib_record_id
JOIN
sierra_view.record_metadata rmb
ON
b.bib_record_id = rmb.id
JOIN
sierra_view.record_metadata rm
ON
cr.id = rm.id AND cr.location_code ~ {{location}}
LEFT JOIN
sierra_view.varfield course
ON
cr.id = course.record_id AND course.varfield_type_code = 'r'
LEFT JOIN
sierra_view.varfield prof
ON
cr.id = prof.record_id AND prof.varfield_type_code = 'p'

GROUP BY 1,3,4,5,6,7,8,9,10,11,12,13,14

--Union with course information for items on reserve
UNION

SELECT
rm.record_type_code||rm.record_num||'a' AS course_number,
STRING_AGG(course.field_content,', ' ORDER BY course.occ_num) AS course,
prof.field_content AS professor,
cr.begin_date::DATE AS start_date,
cr.end_date::DATE AS end_date,
rmi.record_type_code||rmi.record_num||'a' AS record_number,
CASE
	WHEN cil.status_code = 'a' THEN 'active'
	ELSE 'inactive'
END AS reserve_status,
cil.status_change_date::DATE AS status_change_date,
b.best_title AS title,
b.best_author AS author,
i.itype_code_num::VARCHAR AS itype,
stat.name AS item_status,
REPLACE(ip.call_number,'|a','') AS call_number,
i.location_code AS item_location

FROM
sierra_view.course_record cr
LEFT JOIN
sierra_view.course_record_item_record_link cil
ON
cr.id = cil.course_record_id
JOIN
sierra_view.bib_record_item_record_link bil
ON
cil.item_record_id = bil.item_record_id
JOIN
sierra_view.bib_record_property b
ON
bil.bib_record_id = b.bib_record_id
JOIN
sierra_view.record_metadata rmi
ON
bil.item_record_id = rmi.id
JOIN
sierra_view.record_metadata rm
ON
cr.id = rm.id AND cr.location_code ~ {{location}}
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
JOIN
sierra_view.item_record i
ON
rmi.id = i.id
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.item_status_property_myuser stat
ON
i.item_status_code = stat.code
LEFT JOIN
sierra_view.varfield course
ON
cr.id = course.record_id AND course.varfield_type_code = 'r'
LEFT JOIN
sierra_view.varfield prof
ON
cr.id = prof.record_id AND prof.varfield_type_code = 'p'

GROUP BY 1,3,4,5,6,7,8,9,10,11,12,13,14

ORDER BY 2,5,7
)a