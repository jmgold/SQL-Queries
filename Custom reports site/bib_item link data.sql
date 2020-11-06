/*
Jeremy Goldstein
Minuteman Library Network

Extract of link tables along with record numbers from record_metadata
*/

--modify to work for selected link table between item, order and holding

SELECT
l.id,
l.bib_record_id,
rb.record_type_code AS bib_record_type_code,
rb.record_num AS bib_record_num,
l.item_record_id,
r2.record_type_code AS item_record_type_code,
r2.record_num AS item_record_num,
r2.items_display_order

FROM
sierra_view.bib_record_item_record_link l
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code ~ {{location}}
JOIN
sierra_view.record_metadata rb 
ON
l.bib_record_id = rb.id
JOIN
sierra_view.record_metadata r2
ON
l.item_record_id = r2.id