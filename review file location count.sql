--Count the number of owning libraries for each title in a review file
--Use to identify weeding candidates owned elsewhere in the network

--edits from Jim Nicholls, posted to Sierra list on 3/24/16

SELECT
id2reckey(b.id)||'a' AS "bib_record",
b.title AS "bib_title",
count(bi.id) AS "item_count",
count(distinct(i.agency_code_num)) AS "location_count",
array_to_string(
            ARRAY(
               SELECT loc.location_code
                 FROM sierra_view.bib_record_location AS loc
                WHERE b.id = loc.bib_record_id
             ORDER BY 1
            ),
            ','
          ) AS "location codes",
SUM(i.checkout_total) AS "total checkouts",
SUM(i.renewal_total) AS "total renewals"
FROM
sierra_view.bib_view as b 
JOIN sierra_view.bool_set as sb ON b.id = sb.record_metadata_id AND sb.bool_info_id = '369'
JOIN Sierra_view.bib_record_item_record_link as bi ON b.id = bi.bib_record_id
JOIN sierra_view.item_record as i ON bi.item_record_id = i.id
JOIN sierra_view.record_metadata AS rm ON bi.item_record_id = rm.id
group by 1, 2, 5;