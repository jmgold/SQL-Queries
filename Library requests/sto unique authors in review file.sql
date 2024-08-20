SELECT
DISTINCT b.best_author

FROM
sierra_view.bool_set bs
JOIN
sierra_view.bib_record_item_record_link l
ON
bs.record_metadata_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
WHERE
bs.bool_info_id = '413'