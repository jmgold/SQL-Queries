/*
Jeremy Goldstein
Minuteman Library Network

Exports out subject index portion of the phrase_entry table to allow staff to explore this data set
*/

SELECT 
DISTINCT p.id,
p.record_id,
rm.record_type_code,
rm.record_num,
p.occurrence,
p.is_permuted,
p.index_entry,
original_content,
p.insert_title

FROM
sierra_view.phrase_entry p
JOIN
sierra_view.record_metadata rm
ON
p.record_id = rm.id
JOIN
sierra_view.bib_record_item_record_link l
ON
p.record_id = l.bib_record_id AND p.index_tag = 'd'
JOIN
sierra_view.bib_record_location loc
ON
l.bib_record_id = loc.bib_record_id AND loc.location_code ~ '{{location}}'
/*
{{#if include_review_file}}
JOIN
sierra_view.bool_set bs
ON
bs.record_metadata_id = l.bib_record_id AND bs.bool_info_id = {{review_file}}
{{/if include_review_file}}
*/

ORDER BY 2,5
