/*
Jeremy Goldstein
Minuteman Library Network

Bibs with multiple 245 fields
*/

SELECT 
id2reckey(b.bib_record_id)||'a' as bib_record_num,
d1.field_content,
d2.field_content

FROM
sierra_view.bib_record_property 	AS b
JOIN
sierra_view.varfield		AS d1
ON
d1.record_id = b.bib_record_id
	AND d1.marc_tag = '245' AND d1.occ_num = '0'
JOIN
sierra_view.varfield		AS d2
ON
d2.record_id = b.bib_record_id
  AND d2.marc_tag = '245' AND d2.occ_num != d1.occ_num
  AND d2.field_content != d1.field_content

--WHERE
--b.material_code = '2'
GROUP BY
1,2,3
