/*
Jeremy Goldstein
Minuteman Library Network

website version of DIY API based inventory tool
Accepts comma delimited list of barcodes as input
*/


SELECT
p.barcode,
upper(p.call_number_norm || COALESCE(' ' || v.field_content, '') ) as call_number,
i.location_code AS location,
i.item_status_code AS status,
b.best_title AS title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) AS author,
i.last_checkout_gmt::DATE AS last_checkout_date,
i.checkout_total,
i.renewal_total,
i.year_to_date_checkout_total, 
i.record_creation_date_gmt::DATE AS created_date,
i.last_year_to_date_checkout_total,
b.publish_year,
id2reckey(i.id)||'a' AS item_number,
id2reckey(b.bib_record_id)||'a' AS bib_number

FROM
sierra_view.item_record_property		AS p
JOIN sierra_view.item_view			AS i
ON
i.id = p.item_record_id
-- This JOIN will get the Title and Author from the bib
JOIN
sierra_view.bib_record_item_record_link	AS l
ON
l.item_record_id =p.item_record_id
JOIN
sierra_view.bib_record_property			AS b
ON
l.bib_record_id = b.bib_record_id
LEFT OUTER JOIN
sierra_view.varfield					AS v
ON
(i.id = v.record_id) AND (v.varfield_type_code = 'v')

WHERE
p.barcode IN ({{values}})
