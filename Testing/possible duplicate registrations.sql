SELECT
TRIM(v.field_content) AS email,
STRING_AGG(rm.record_type_code||rm.record_num||'a',', ') AS pnumber,
STRING_AGG(n.last_name||' '||n.first_name||' '||n.middle_name,', ') AS NAME,
STRING_AGG(TO_CHAR(rm.creation_date_gmt, 'YYYY-MM-DD'),', ') AS creation_date

FROM
sierra_view.patron_record p
JOIN
sierra_view.varfield v
ON
p.id = v.record_id AND v.varfield_type_code = 'z'
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id AND rm.creation_date_gmt >= '2024-05-01'
JOIN
sierra_view.patron_record_fullname n
ON
p.id = n.patron_record_id
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id

GROUP BY 1
HAVING COUNT(DISTINCT p.id) > 1 AND COUNT(DISTINCT a.addr1) > 1