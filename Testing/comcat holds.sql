/*
Jeremy Goldstein
Minuteman Library Network

Id's patrons with comcat holds
currently looking at holds ready for pickup
expand to checkout data and outstanding holds as well
build admin builder tool for Libby
*/

SELECT
p.record_type_code||p.record_num||'a',
rm.record_type_code||rm.record_num||'a',
v.field_content,
b.field_content,
FROM
sierra_view.hold h
JOIN
sierra_view.record_metadata rm
ON
h.record_id = rm.id AND rm.campus_code = 'ncip' AND h.status IN ('b','i')
JOIN
sierra_view.record_metadata p
ON
h.patron_record_id = p.id
LEFT JOIN
sierra_view.varfield v
ON
h.patron_record_id = v.record_id AND v.varfield_type_code = 'v'
JOIN
sierra_view.varfield b
ON
rm.id = b.record_id AND b.varfield_type_code = 'b'