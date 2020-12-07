/*
Jeremy Goldstein
Minuteman Library Network

Pulls together item record tables into a single data extract
*/

SELECT
DISTINCT i.id,
rm.record_type_code,
rm.record_num,
rm.creation_date_gmt,
rm.campus_code,
rm.num_revisions,
rm.record_last_updated_gmt,
rm.previous_last_updated_gmt,
ip.call_number,
ip.call_number_norm,
ip.barcode,
i.icode1,
i.icode2,
i.itype_code_num,
it.name AS itype_name,
i.location_code,
loc.name AS location_name,
i.agency_code_num,
a.name AS agency_name,
i.item_status_code,
st.name AS item_status_name,
i.price,
i.last_checkin_gmt,
i.checkout_total,
i.renewal_total,
i.last_year_to_date_checkout_total,
i.year_to_date_checkout_total,
i.copy_num,
i.checkout_statistic_group_code_num,
so.name AS checkout_statistic_group_name,
i.checkin_statistics_group_code_num,
si.name AS checkin_statistic_group_name,
i.use3_count,
i.last_checkout_gmt,
i.internal_use_count,
i.copy_use_count,
i.item_message_code,
i.opac_message_code,
i.is_suppressed,
i.is_available_at_library

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
sierra_view.statistic_group_myuser AS so
ON
i.checkout_statistic_group_code_num = so.code
JOIN
sierra_view.statistic_group_myuser AS si
ON
i.checkin_statistics_group_code_num = si.code
JOIN
sierra_view.item_status_property_myuser st
ON
i.item_status_code = st.code
{{#if include_review_file}}
JOIN
sierra_view.bool_set bs
ON
bs.record_metadata_id = i.id AND bs.bool_info_id = {{review_file}}
{{/if include_review_file}}

WHERE
i.location_code ~ '{{location}}'
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.