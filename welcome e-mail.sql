--query used to populate a welcome e-mail to new patrons (generated via python query)

SELECT
n.first_name,
n.last_name,
min(v.field_content) as email,
p.barcode,
CASE
WHEN u.field_content IS NOT NULL THEN u.field_content
ELSE 'You have not set a username <a href="https://library.minlib.net/screens/username.html"> click here for more information</a>'
END as user_name,
CASE
WHEN p.patron_agency_code_num = 1 THEN 'Belmont Public Library'
WHEN p.patron_agency_code_num = 2 THEN 'Public Library of Brookline'
WHEN p.patron_agency_code_num = 3 THEN 'Cambridge Public Library'
WHEN p.patron_agency_code_num = 4 THEN 'Concord Public Library'
WHEN p.patron_agency_code_num = 5 THEN 'Dedham Public Library'
WHEN p.patron_agency_code_num = 6 THEN 'Lexington Public Library'
WHEN p.patron_agency_code_num = 7 THEN 'MassBay Community College'
WHEN p.patron_agency_code_num = 8 THEN 'Newton Public Library'
WHEN p.patron_agency_code_num = 9 THEN 'Somerville Public Library'
WHEN p.patron_agency_code_num = 10 THEN 'Watertown Public Library'
WHEN p.patron_agency_code_num = 11 THEN 'Wellesley Public Library'
WHEN p.patron_agency_code_num = 12 THEN 'Acton Public Library'
WHEN p.patron_agency_code_num = 13 THEN 'Arlington Public Library'
WHEN p.patron_agency_code_num = 14 THEN 'Ashland Public Library'
WHEN p.patron_agency_code_num = 15 THEN 'Bedford Public Library'
WHEN p.patron_agency_code_num = 16 THEN 'Dean College'
WHEN p.patron_agency_code_num = 17 THEN 'Dover Public Library'
WHEN p.patron_agency_code_num = 18 THEN 'Framingham Public Library'
WHEN p.patron_agency_code_num = 19 THEN 'Framingham State University'
WHEN p.patron_agency_code_num = 20 THEN 'Franklin Public Library'
WHEN p.patron_agency_code_num = 21 THEN 'Holliston Public Library'
WHEN p.patron_agency_code_num = 22 THEN 'Lasell Public Library'
WHEN p.patron_agency_code_num = 23 THEN 'Lincoln Public Library'
WHEN p.patron_agency_code_num = 24 THEN 'Maynard Public Library'
WHEN p.patron_agency_code_num = 25 THEN 'Medfield Public Library'
WHEN p.patron_agency_code_num = 26 THEN 'Medford Public Library'
WHEN p.patron_agency_code_num = 27 THEN 'Medway Public Library'
WHEN p.patron_agency_code_num = 28 THEN 'Millis Public Library'
WHEN p.patron_agency_code_num = 29 THEN 'Mount Ida College'
WHEN p.patron_agency_code_num = 30 THEN 'Natick Public Library'
WHEN p.patron_agency_code_num = 31 THEN 'Needham Public Library'
WHEN p.patron_agency_code_num = 33 THEN 'Norwood Public Library'
WHEN p.patron_agency_code_num = 34 THEN 'Stow Public Library'
WHEN p.patron_agency_code_num = 35 THEN 'Sudbury Public Library'
WHEN p.patron_agency_code_num = 36 THEN 'Waltham Public Library'
WHEN p.patron_agency_code_num = 37 THEN 'Wayland Public Library'
WHEN p.patron_agency_code_num = 38 THEN 'Weston Public Library'
WHEN p.patron_agency_code_num = 39 THEN 'Westwood Public Library'
WHEN p.patron_agency_code_num = 40 THEN 'Winchester Public Library'
WHEN p.patron_agency_code_num = 41 THEN 'Woburn Public Library'
WHEN p.patron_agency_code_num = 43 THEN 'Pine Manor College'
WHEN p.patron_agency_code_num = 44 THEN 'Regis College'
WHEN p.patron_agency_code_num = 45 THEN 'Sherborn Public Library'
Else 'Unknown'
END AS library
FROM
sierra_view.patron_view as p
JOIN		
sierra_view.varfield v		
ON		
p.id = v.record_id and v.varfield_type_code = 'z'
LEFT OUTER JOIN		
sierra_view.varfield u		
ON		
p.id = u.record_id and u.varfield_type_code = 'w'
JOIN
sierra_view.patron_record_fullname n
ON
p.id = n.patron_record_id
JOIN
sierra_view.record_metadata m
ON
p.record_num = m.record_num
WHERE
m.creation_date_gmt  > (localtimestamp - interval '1 day')
AND p.patron_agency_code_num NOT IN ('32','42','46','47')
group by 5, 2, 1, 4, 6
