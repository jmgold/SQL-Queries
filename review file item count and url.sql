SELECT
'b'||b.record_num||'a' AS "bib_record",
b.title AS "bib_title",
a.item_count AS "item_count",
'i'||rm.record_num||'a' AS "item_record",
ir.location_code AS "location_code",
'http://library.minlib.net/record=b'||b.record_num||'a' AS "URL"
FROM
(SELECT
l.bib_record_id AS "bib_record_id",
count(l.id) AS "item_count"
FROM
sierra_view.bib_record_item_record_link l
GROUP BY l.bib_record_id
HAVING count(l.id) > 1) AS a
INNER JOIN sierra_view.bib_view b ON a.bib_record_id = b.id
INNER JOIN sierra_view.bool_set sb ON a.bib_record_id = sb.record_metadata_id
INNER JOIN sierra_view.bool_info bo ON bo.id = sb.bool_info_id AND sb.bool_info_id ='107'
INNER JOIN Sierra_view.bib_record_item_record_link bi ON b.id = bi.bib_record_id
INNER JOIN sierra_view.record_metadata rm ON bi.item_record_id = rm.id
INNER JOIN sierra_view.item_record ir ON bi.item_record_id = ir.id;