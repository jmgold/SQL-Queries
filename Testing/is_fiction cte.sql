SELECT
*
FROM(
SELECT
id2reckey(subjects.record_id)||'a',
subjects.bib_level_code,
subjects.record_type_code,
subjects.lit_form,
CASE 
	WHEN subjects.subject_count > 0 THEN true
	ELSE false
END AS is_fiction,
subjects.subjects

FROM
(SELECT
d.record_id,
l.bib_level_code,
l.record_type_code,
f.p33 AS lit_form,
COUNT(d.content) FILTER(WHERE LOWER(d.content) ~ '(\yfiction)|(pictorial)|(tales)|(comic books)|(\ydrama)') AS subject_count,
STRING_AGG(d.content,',') AS subjects

FROM
--sierra_view.phrase_entry d
sierra_view.subfield d
JOIN
sierra_view.bib_record_property b
ON
d.record_id = b.bib_record_id 
AND b.material_code NOT IN ('7','8','b','e','j','k','m','n')
AND d.field_type_code = 'd' AND d.tag = 'v'
LEFT JOIN
sierra_view.control_field f
ON
b.bib_record_id = f.record_id
LEFT JOIN
sierra_view.leader_field l
ON
b.bib_record_id = l.record_id

GROUP BY 1,2,3,4

)subjects
)a

WHERE a.bib_level_code = 'm' AND a.record_type_code = 'a' AND a.lit_form NOT IN ('0','e','i','p','s') AND a.is_fiction = true
