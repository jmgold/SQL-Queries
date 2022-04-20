SELECT
b.best_title,
(SELECT
SUBSTRING(e.index_entry FROM '^[0-9]{9}[(0-9,x)|(0-9){4}|(0-9){3}x]') AS ISBN
FROM
sierra_view.phrase_entry e
WHERE
e.record_id = b.bib_record_id AND e.varfield_type_code = 'i'
ORDER BY e.occurrence
LIMIT 1)isbn
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code ~'^ntn' AND i.icode1 = '6231'