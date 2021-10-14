SELECT
DISTINCT rm.record_type_code||rm.record_num||'a' AS pnumber,
email.field_content AS email


FROM
sierra_view.fine f
JOIN
sierra_view.patron_record p
ON
f.patron_record_id = p.id
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id
JOIN
sierra_view.item_record i
ON
f.item_record_metadata_id = i.id
JOIN
sierra_view.varfield email
ON
p.id = email.record_id AND email.varfield_type_code = 'z'

WHERE 
/*
--Patrons with existing CAM J/YA replacement fees for Cambridge-owned items that were checked out at a Cambridge location
i.location_code ~ '^ca'
AND SUBSTRING(i.location_code,4,1) IN ('y','j')
AND (f.loanrule_code_num BETWEEN 68 AND 78 OR f.loanrule_code_num BETWEEN 555 AND 563) 
AND f.charge_code = '3'
*/
/*
--Patrons with existing CAM J/YA replacement fees for Cambridge-owned items that were checked out at a location other than Cambridge
i.location_code ~ '^ca'
AND SUBSTRING(i.location_code,4,1) IN ('y','j')
AND f.loanrule_code_num NOT BETWEEN 68 AND 78 AND f.loanrule_code_num NOT BETWEEN 555 AND 563 
AND f.charge_code = '3'
*/
--Patrons with existing CAM overdue fines
f.charge_code IN ('2','4','6')
AND (f.loanrule_code_num BETWEEN 68 AND 78 OR f.loanrule_code_num BETWEEN 555 AND 563)