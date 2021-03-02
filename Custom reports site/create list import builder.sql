SELECT * FROM
(
SELECT
{{record_type}} AS rec_num
/*
options are
DISTINCT id2reckey(o.order_record_id)||'a'
DISTINCT id2reckey(i.id)||'a'
DISTINCT id2reckey(b.id)||'a'
*/

FROM
sierra_view.bib_record b
LEFT JOIN
sierra_view.bib_record_item_record_link l
ON b.id = l.bib_record_id
LEFT JOIN
sierra_view.bib_record_order_record_link ol
ON
b.id = ol.bib_record_id
LEFT JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code ~ {{location}}
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
LEFT JOIN
sierra_view.order_record_cmf o
ON
ol.order_record_id = o.order_record_id AND o.location_code ~ {{location}}

JOIN
sierra_view.phrase_entry v
ON
{{index_field}}
/*
options are
b.id = v.record_id AND v.index_tag = 'i'
l.item_record_id = v.record_id AND v.index_tag = 'b'
*/
AND SUBSTRING(v.index_entry FROM '^[0-9]+')::NUMERIC IN ({{values}})
) a
WHERE
rec_num IS NOT NULL