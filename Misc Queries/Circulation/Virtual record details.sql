/*
Jeremy Goldstein
Minuteman Library Network

Provides details of virtual records in the system
Within Mass these are all items borrowed via the Commonwealth Catalog using AutoGraphics ILL
*/

SELECT
rm.creation_date_gmt::DATE AS created_date,
rm.record_type_code||rm.record_num||'a' AS item_number,
rmb.record_type_code||rmb.record_num||'a' AS bib_number,
b.best_title AS title,
b.best_author AS author,
b.material_code AS mattype,
i.location_code,
i.itype_code_num,
CASE
	WHEN o.due_gmt IS NOT NULL THEN 'out'
	ELSE i.item_status_code
END AS status,
i.checkout_statistic_group_code_num,
rm.record_last_updated_gmt::DATE AS updated_date,
COALESCE(TO_CHAR(o.due_gmt,'yyyy-mm-dd'),'') AS due_date

FROM
sierra_view.item_record i
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id AND i.virtual_type_code = '$'
LEFT JOIN
sierra_view.checkout o
ON
i.id = o.item_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.record_metadata rmb
ON
b.bib_record_id = rmb.id

ORDER BY rm.creation_date_gmt