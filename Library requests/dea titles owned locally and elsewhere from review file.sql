/*
Jeremy Goldstein
Minuteman Library Network
Gathers bibs from a review file and identifies the number of attached items owned by Dean vs other locations
*/

SELECT
rm.record_type_code||rm.record_num||'a' AS record_number,
bp.best_title AS title,
bp.best_author AS author,
COUNT(i.id) AS total_copies,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^dea') AS total_dean_copies,
COUNT(i.id) FILTER(WHERE i.location_code!~ '^dea') AS total_other_copies,
STRING_AGG(p.index_entry,', ') FILTER (WHERE i.location_code ~ '^dea') AS barcodes

FROM
sierra_view.bool_info b
JOIN
sierra_view.bool_set bs
ON
b.id = bs.bool_info_id AND b.id = '579'
JOIN
sierra_view.bib_record_item_record_link l
ON
bs.record_metadata_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
JOIN
sierra_view.record_metadata rm
ON
l.bib_record_id = rm.id
JOIN
sierra_view.bib_record_property bp
ON
l.bib_record_id = bp.bib_record_id
JOIN
sierra_view.phrase_entry p
ON
i.id = p.record_id AND p.index_tag = 'b'

GROUP BY 1,2,3