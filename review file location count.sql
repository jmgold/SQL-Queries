--Count the number of owning libraries for each title in a review file
--Use to identify weeding candidates owned elsewhere in the network

--item count and the sums do not produce accurate counts
SELECT
id2reckey(b.id)||'a' AS "bib_record",
b.title AS "bib_title",
--count(bi.id) AS "item_count",
count(distinct(i.agency_code_num)) AS "location_count",
string_agg(distinct(loc.location_code), ',') AS "location codes"
--SUM(i.checkout_total) AS "total checkouts",
--SUM(i.renewal_total) AS "total renewals"
FROM
sierra_view.bib_view as b 
JOIN sierra_view.bool_set as sb ON b.id = sb.record_metadata_id AND sb.bool_info_id = '46'
JOIN Sierra_view.bib_record_item_record_link as bi ON b.id = bi.bib_record_id
JOIN sierra_view.record_metadata as rm ON bi.item_record_id = rm.id
JOIN sierra_view.item_record as i ON bi.item_record_id = i.id
JOIN sierra_view.bib_record_location AS loc ON b.id = loc.bib_record_id
group by 1, 2;