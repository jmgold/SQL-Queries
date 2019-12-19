/*
Jeremy Goldstein
Minuteman Library Network

Takes two review files to find either unique or duplicate records between them
*/

SELECT
id2reckey(bs.record_metadata_id)||'a' AS record_number

FROM
sierra_view.bool_info bi
JOIN
sierra_view.bool_set bs
ON
bi.id = bs.bool_info_id

WHERE bs.bool_info_id = {{review_file_a}}

{{comparison}}
--EXCEPT
--INTERSECT

SELECT
id2reckey(bs.record_metadata_id)||'a'

FROM
sierra_view.bool_info bi
JOIN
sierra_view.bool_set bs
ON
bi.id = bs.bool_info_id

WHERE bs.bool_info_id = {{review_file_b}}