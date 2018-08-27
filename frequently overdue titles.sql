SELECT
b.best_title,
b.best_author
--COUNT(m.id)
FROM
sierra_view.fine f
JOIN
sierra_view.record_metadata m
ON
f.item_record_metadata_id = m.id AND m.record_type_code = 'i'
JOIN
sierra_view.item_view i
ON
m.record_num = i.record_num
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id AND b.material_code = 'a'
WHERE
f.charge_code = '2'
GROUP BY 1,2
ORDER BY COUNT(m.id) desc
LIMIT 100
