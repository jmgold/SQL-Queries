/*
Jeremy Goldstein
Minuteman Library Network
shelf list for all items owned by a location
*/

SELECT
DISTINCT rm.record_type_code||rm.record_num||'a' AS item_number,
loc.name AS location,
TRIM(REPLACE(ip.call_number,'|a','')) AS call_number,
COALESCE(vol.field_content,'') AS volume,
b.best_title AS title,
b.best_author AS author,
b.publish_year,
rm.creation_date_gmt::DATE AS creation_date,
rm.record_last_updated_gmt::DATE AS last_updated,
ip.barcode,
i.icode1 AS scat,
i.itype_code_num,
it.name AS itype_name,
CASE
	WHEN co.id IS NOT NULL THEN 'CHECKED OUT'
	ELSE st.name
END AS item_status,
i.price::MONEY AS price,
i.last_checkin_gmt::DATE AS last_checkin,
i.last_checkout_gmt::DATE AS last_checkout,
i.checkout_total,
i.renewal_total,
i.last_year_to_date_checkout_total,
i.year_to_date_checkout_total,
i.use3_count,
i.internal_use_count,
i.copy_use_count

FROM
sierra_view.item_record i
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code
JOIN
sierra_view.location_myuser loc
ON
i.location_code = loc.code
JOIN
sierra_view.agency_property_myuser a
ON
i.agency_code_num = a.code
JOIN
sierra_view.item_status_property_myuser st
ON
i.item_status_code = st.code
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
LEFT JOIN
sierra_view.varfield vol
ON
i.id = vol.record_id AND vol.varfield_type_code = 'v'
LEFT JOIN
sierra_view.checkout co
ON
i.id = co.item_record_id

WHERE
i.location_code ~ '{{location}}'
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
AND i.item_status_code NOT IN ({{item_status_codes}})
AND b.material_code IN ({{mat_type}})
AND {{age_level}}
--age_level options are
--(i.itype_code_num NOT BETWEEN '100' AND '183' AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')) --adult
--(i.itype_code_num BETWEEN '150' AND '183' OR SUBSTRING(i.location_code,4,1) = 'j') --juv
--(i.itype_code_num BETWEEN '100' AND '133' OR SUBSTRING(i.location_code,4,1) = 'y') --ya
--i.location_code ~ '\w' --all

ORDER BY 2,3,4