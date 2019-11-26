/*
Jeremy Goldstein
Minuteman Library Network

circ_trans export for use with Tableau circulation dashboard
*/

SELECT 
C.id,
C.transaction_gmt,
C.application_name,
C.op_code,
C.patron_record_id,
SUBSTRING(s.name FROM 1 FOR 3) AS stat_group,
C.due_date_gmt,
i.name AS itype,
p.name AS ptype,
C.loanrule_code_num,
M.name AS mattype,
CASE
WHEN SUBSTRING(C.item_location_code FROM 4 FOR 1) = 'y' OR C.itype_code_num BETWEEN '100' AND '133' THEN 'YA'
WHEN SUBSTRING(C.item_location_code FROM 4 FOR 1) = 'j' OR C.itype_code_num BETWEEN '150' AND '183' THEN 'CHILDRENS'
ELSE 'ADULT'
END AS audience,
SUBSTRING(C.item_location_code FROM 1 FOR 3) AS owning_location
FROM
sierra_view.circ_trans C
JOIN
sierra_view.bib_record_item_record_link l
ON
C.item_record_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.statistic_group_myuser s
ON
C.stat_group_code_num = s.code
JOIN
sierra_view.itype_property_myuser i
ON
C.itype_code_num = i.code
JOIN
sierra_view.ptype_property_myuser p
ON
C.ptype_code = p.value::varchar
JOIN
sierra_view.material_property_myuser M
ON
b.material_code = M.code