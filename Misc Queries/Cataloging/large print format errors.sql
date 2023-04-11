/*
Jeremy Goldstein
Minuteman Library Network

Identifies items without a mattype of large print that could be identified as large print within Aspen Discover
*/

SELECT
DISTINCT rm.record_type_code||rm.record_num||'a' AS bib_number,
b.material_code,
b.best_title,
b.best_author

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id
LEFT JOIN
sierra_view.control_field cf
ON
rm.id = cf.record_id
LEFT JOIN
sierra_view.leader_field lf
ON
rm.id = lf.record_id
LEFT JOIN
sierra_view.subfield s
ON
rm.id = s.record_id AND (s.marc_tag||s.tag IN ('245h','245k','245p','655a','250a') OR s.marc_tag = '300')

WHERE
b.material_code != '2'
AND (
(LOWER(lf.record_type_code) IN ('a','t') AND (cf.control_num = 8 AND cf.p23= 'd'))
OR (cf.control_num = 7 AND LOWER(cf.p00) = 't' AND LOWER(cf.p01) = 'b')
OR (s.marc_tag||s.tag IN ('245h','245k','245p','655a','250a') AND LOWER(s.content) LIKE '%large print%')
OR (s.marc_tag||s.tag IN ('655a','250a') AND LOWER(s.content) LIKE '%large type%')
OR (s.marc_tag = '300' AND s.tag != 'e' AND LOWER(s.content) ~ 'large (type|print)')
)

