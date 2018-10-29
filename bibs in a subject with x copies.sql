SELECT
id2reckey(b.bib_record_id)||'a',
b.best_title,
b.best_author,
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
bi.item_record_id = i.id AND i.item_status_code NOT IN ('m', 'n', 'z', 'o', '$', 'w', 'd', 'r', 'e', 'q')--and i.is_available_at_library = 'true'
JOIN
sierra_view.record_metadata m
ON
bi.item_record_id = m.id AND m.deletion_date_gmt IS NULL
JOIN
sierra_view.varfield_view v
ON
b.bib_record_id = v.record_id AND v.varfield_type_code = 'd' AND (v.field_content LIKE '%cooking%' OR v.field_content LIKE '%Cooking%' OR v.field_content LIKE '%cookbooks%')
GROUP BY
1,2,3,4
HAVING
COUNT(distinct bi.id) >= '25'
 