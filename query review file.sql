--Jeremy Goldstein
--Minuteman Library Network

--Template for running query against a review file

SELECT
bib_view.record_type_code,
bib_view.record_num,
bib_view.title
FROM
sierra_view.bool_set,
sierra_view.bib_view,
sierra_view.bool_info
WHERE
bool_set.bool_info_id =
bool_info.id AND
bib_view.id = bool_set.record_metadata_id AND
--enter review file number
bool_info.id = '107';
