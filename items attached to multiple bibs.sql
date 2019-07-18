--- find same item record linked to multiple bib records 
--- shared by Ray Voelker

SELECT
r.record_type_code || r.record_num || 'a' as bib_record_num,
ir.record_type_code || ir.record_num || 'a' as item_record_num,
i.location_code

FROM
sierra_view.record_metadata as r

JOIN
sierra_view.bib_record_item_record_link as l
ON
  l.bib_record_id = r.id

JOIN
sierra_view.record_metadata as ir
ON
  ir.id = l.item_record_id

JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id

WHERE
l.item_record_id IN (
	SELECT
	l.item_record_id
	-- ,count(item_record_id)

	FROM
	sierra_view.bib_record_item_record_link as l

	GROUP BY
	l.item_record_id

	HAVING
	count(item_record_id) > 1
);