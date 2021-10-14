SELECT
DISTINCT ON (b.best_title)
COALESCE(REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1),'') AS Author,
b.best_title AS Title,
i.location_code AS Location
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
AND i.location_code ~ '^fpl'
WHERE
b.publish_year >= 2010 AND b.material_code = 'a'

