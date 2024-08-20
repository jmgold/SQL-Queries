SELECT
b.bib_record_id AS id,
STRING_AGG(d.index_entry,' ') AS subjects

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.phrase_entry d
ON
b.bib_record_id = d.record_id AND d.index_tag = 'd'
JOIN
sierra_view.bib_record_location l
ON
b.bib_record_id = l.bib_record_id AND l.location_code != 'multi'

WHERE b.material_code = 'a' AND b.publish_year = '2022'

GROUP BY 1
HAVING COUNT(l.location_code) FILTER(WHERE SUBSTRING(l.location_code,4,1) = 'j') = 0
ORDER BY b.bib_record_id desc
LIMIT 1000