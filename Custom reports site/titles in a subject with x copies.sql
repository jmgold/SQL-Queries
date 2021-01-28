SELECT
id2reckey(b.bib_record_id)||'a' AS bib_number,
b.best_title AS title,
b.best_author AS author,
b.publish_year,
COUNT(distinct bi.id) AS copies
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link bi
ON b.bib_record_id = bi.bib_record_id
JOIN
sierra_view.item_record i
ON
bi.item_record_id = i.id AND i.item_status_code NOT IN ({{item_status_codes}})
{{#if limit_available}}and i.is_available_at_library = 'true'{{/if limit_available}}
JOIN
sierra_view.phrase_entry p
ON
b.bib_record_id = p.record_id AND p.index_tag = 'd' AND REPLACE(p.index_entry, ' ', '') LIKE TRANSLATE(REGEXP_REPLACE(LOWER('%{{subject}}%'),'\|[a-z]','','g'), ' .,-()', '')

WHERE
b.material_code IN ({{mat_type}})
GROUP BY
1,2,3,4
HAVING
COUNT(distinct bi.id) >= {{copies}}