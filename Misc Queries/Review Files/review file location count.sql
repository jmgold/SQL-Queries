/*
Jeremy Goldstein
Minuteman Library Network
Count the number of owning libraries for each title in a review file along with some circ totals
Use to identify weeding candidates owned elsewhere in the network

based on edits from Jim Nicholls, posted to Sierra list on 3/24/16
*/
SELECT
rm.record_type_code||rm.record_num||'a' AS bib_number
,bp.best_title AS bib_title
,COUNT(i.id) AS item_count
,COUNT(DISTINCT SUBSTRING(i.location_code,1,3)) AS location_count
,STRING_AGG(SUBSTRING(i.location_code,1,3),',') AS location_codes
,SUM(i.checkout_total) AS total_checkout
,SUM(i.renewal_total) AS total_renewals

FROM
sierra_view.bib_record b 
JOIN
sierra_view.record_metadata rm
ON
b.id = rm.id
JOIN
sierra_view.bib_record_property bp
ON
b.id = bp.bib_record_id
JOIN
sierra_view.bool_set sb
ON
b.id = sb.record_metadata_id 
--specify your review file number, must contain bib records
AND sb.bool_info_id = '201'
JOIN
sierra_view.bib_record_item_record_link bi
ON
b.id = bi.bib_record_id
JOIN
sierra_view.item_record i
ON
bi.item_record_id = i.id

GROUP BY 1,2