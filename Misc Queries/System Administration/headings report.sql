/*
Jeremy Goldstein
Minuteman Library Network

Case statement shared by David W. Green on Sierra_ILS slack channel 7/12/21

Generates headings report
*/

SELECT
CASE
	WHEN c.condition_code_num = '1' THEN 'Used for first time'
	WHEN c.condition_code_num = '2' THEN 'Invalid'
	WHEN c.condition_code_num = '3' THEN 'Duplicate Entry'
	WHEN c.condition_code_num = '4' THEN 'Blind Reference'
	WHEN c.condition_code_num = '5' THEN 'Duplicate Authority'
	WHEN c.condition_code_num = '6' THEN 'Updated Heading'
	WHEN c.condition_code_num = '7' THEN 'Near Match'
	WHEN c.condition_code_num = '8' THEN 'Busy Record'
	WHEN c.condition_code_num = '9' THEN 'Non-Unique 4XX'
	WHEN c.condition_code_num = '10' THEN 'Cross-Thesaurus'
	WHEN c.condition_code_num = '11' THEN 'Missing Form or |8'
	WHEN c.condition_code_num = '12' THEN 'Missing Form 2'
	ELSE c.condition_code_num::VARCHAR
	END AS condition,
rm.record_type_code||rm.record_num||'a' AS record_num,
c.index_tag,
c.index_entry,
c.statistics_group_code_num,
c.process_gmt,
c.program_code,
c.one_xx_entry,
rma.record_type_code||rma.record_num||'a' AS authority_record,
c.old_field,
c.new_240_field,
c.field,
c.cataloging_date_gmt::DATE AS catalog_date,
c.index_prev,
c.index_next,
c.correct_heading,
c.author,
c.title

FROM
sierra_view.catmaint c
JOIN
sierra_view.record_metadata rm
ON
c.record_metadata_id = rm.id
LEFT JOIN
sierra_view.record_metadata rma
ON
c.authority_record_metadata_id = rma.id

ORDER BY c.condition_code_num, process_gmt
