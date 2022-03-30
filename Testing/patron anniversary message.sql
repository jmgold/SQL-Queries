SELECT
MIN(n.first_name),
MIN(n.last_name),
MIN(v.field_content) AS email,
TO_CHAR(rm.creation_date_gmt,'Mon DD, YYYY'),
p.id
FROM
sierra_view.patron_record AS p
JOIN		
sierra_view.varfield v		
ON		
p.id = v.record_id AND v.varfield_type_code = 'z'
JOIN
sierra_view.patron_record_fullname n
ON
p.id = n.patron_record_id
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id
WHERE
rm.creation_date_gmt::DATE BETWEEN '2003-06-22' AND (CURRENT_DATE - INTERVAL '1 day')
AND
(CURRENT_DATE - rm.creation_date_gmt::DATE)::INT % 1095 = 0
--optional filter
--AND p.activity_gmt::DATE > CURRENT_DATE - INTERVAL '1 year'
GROUP BY 5, 4

--load in a subset of the 97k records brought in from the Sierra migration
UNION

SELECT
MIN(n.first_name),
MIN(n.last_name),
MIN(v.field_content) AS email,
TO_CHAR(rm.creation_date_gmt,'Mon DD, YYYY'),
p.id
FROM
sierra_view.patron_record AS p
JOIN		
sierra_view.varfield v		
ON		
p.id = v.record_id AND v.varfield_type_code = 'z'
JOIN
sierra_view.patron_record_fullname n
ON
p.id = n.patron_record_id
JOIN
(
--97493 patrons as of 2/25/22
SELECT
id,
creation_date_gmt
FROM
sierra_view.record_metadata
WHERE
creation_date_gmt::DATE < '2003-06-22' AND record_type_code = 'p'
ORDER BY record_num
LIMIT 90 
OFFSET (DATE_PART('doy',CURRENT_DATE) * ((DATE_PART('year',CURRENT_DATE)::INT % 3) + 1))
) rm
ON
p.id = rm.id
GROUP BY 5, 4
ORDER BY 4