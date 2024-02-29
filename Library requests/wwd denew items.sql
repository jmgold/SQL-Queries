/*
request from Westwood to find older items still on their new shelf that are currently available
*/

SELECT
ip.barcode,
ip.call_number,
b.best_title,
b.best_author,
rm.creation_date_gmt::DATE AS created_date

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id AND i.location_code = 'wwdan' AND i.item_status_code = '-'
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id AND rm.creation_date_gmt::DATE BETWEEN '2022-07-01' AND '2023-07-31'
LEFT JOIN
sierra_view.checkout o
ON
i.id = o.item_record_id
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id

WHERE o.id IS NULL

ORDER BY 5,2