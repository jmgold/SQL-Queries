/*
Jeremy Goldstein
Minuteman Library Network
Template for running query against a review file
pulls title,author, record number from a file containing bib records
*/

SELECT
rm.record_type_code||rm.record_num||'a' AS bnumber,
bp.best_title AS title,
bp.best_author AS author

FROM
sierra_view.bool_set bs
JOIN
sierra_view.bool_info bi
ON
bs.bool_info_id = bi.id
JOIN
sierra_view.bib_record b
ON
bs.record_metadata_id = b.id
JOIN
sierra_view.record_metadata rm
ON
b.id = rm.id
JOIN
sierra_view.bib_record_property bp
ON
b.id = bp.bib_record_id

WHERE
--enter review file number
bi.id = '517'
