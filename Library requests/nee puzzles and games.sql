/*
Elaine Greenfield & Jeremy Goldstein
Minuteman Library Network

Report is run once a month to track the in library usage of
Needham's puzzles and games records.
*/

SELECT
	record_metadata.record_type_code||record_metadata.record_num AS item_rec_number, 
	bib_record_property.best_title AS title, 
	item_record.use3_count AS item_use_3

FROM sierra_view.item_record
JOIN sierra_view.record_metadata
	ON sierra_view.item_record.id = record_metadata.id
JOIN sierra_view.bib_record_item_record_link
	ON item_record.id = bib_record_item_record_link.item_record_id
JOIN sierra_view.bib_record_property
	ON bib_record_item_record_link.bib_record_id = bib_record_property.bib_record_id

WHERE record_metadata.record_type_code||record_metadata.record_num IN ('i19472209','i19480658')