/*
Jeremy Goldstein
Minuteman Library Network

Identifies patrons whose cards will expire in 30 days
*/

SELECT
MIN(n.first_name) AS first_name,
MIN(n.last_name) AS last_name,
MIN(v.field_content) AS email,
TO_CHAR(p.expiration_date_gmt,'Mon DD, YYYY') AS exp_date,
p.record_type_code||p.record_num||'a' AS record_number

FROM
sierra_view.patron_view AS p
JOIN		
sierra_view.varfield v		
ON		
p.id = v.record_id AND v.varfield_type_code = 'z'
JOIN
sierra_view.patron_record_fullname n
ON
p.id = n.patron_record_id

WHERE
p.expiration_date_gmt::DATE = (CURRENT_DATE + INTERVAL '30 days')
GROUP BY 5, 4
