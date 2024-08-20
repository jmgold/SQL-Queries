/*
Jeremy Goldstein
Minuteman Library Network

Finds update date subfields from our census field where the date contains missing/extra characters
can lead to the geocoder script failing in the future.
*/

SELECT
rm.record_type_code||rm.record_num||'a',
rm.id,
s.content

FROM
sierra_view.subfield s
JOIN
sierra_view.record_metadata rm
ON
s.record_id = rm.id AND rm.record_type_code = 'p' AND s.field_type_code = 'k' AND s.tag = 'd'
AND TRIM(s.content) !~ '^\d{4}\-\d{2}\-\d{2}$'
