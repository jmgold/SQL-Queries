/*
Jeremy Goldstein
Minuteman Library Network

Pulls together order record tables into a single data extract
*/

SELECT
rm.id,
rm.record_type_code,
rm.record_num,
rm.creation_date_gmt,
rm.num_revisions,
rm.record_last_updated_gmt,
rm.previous_last_updated_gmt,
o.accounting_unit_code_num,
an.name AS accounting_unit_name,
o.acq_type_code,
acqt.name AS acq_type_name,
o.ocode2,
o.ocode4,
o.is_suppressed,
o.estimated_price,
o.form_code,
form.name AS form_name,
o.order_date_gmt,
o.order_note_code,
note.name AS order_note_name,
o.order_type_code,
ot.name AS order_type_name,
o.received_date_gmt,
o.receiving_location_code,
o.billing_location_code,
o.order_status_code,
os.name AS order_status_name,
o.vendor_record_code,
vn.field_content AS vendor_record_name,
o.language_code,
o.blanket_purchase_order_num,
o.fund_copies_paid,
STRING_AGG(cmf.fund_code,',') AS fund_codes_master,
STRING_AGG(fm.code,',') AS fund_codes,
STRING_AGG(fn.name,',') AS fund_names,
STRING_AGG(cmf.location_code,',') AS location_codes,
STRING_AGG(cmf.copies::VARCHAR,',') AS copies

FROM
sierra_view.order_record o
JOIN
sierra_view.record_metadata rm
ON
o.id = rm.id
JOIN
sierra_view.order_record_cmf cmf
ON
o.id = cmf.order_record_id
JOIN
sierra_view.order_type_property_myuser ot
ON
o.order_type_code = ot.code
JOIN
sierra_view.acq_type_property_myuser acqt
ON
o.acq_type_code = acqt.code
JOIN
sierra_view.form_property_myuser form
ON
o.form_code = form.code
JOIN
sierra_view.order_note_property_myuser note
ON
o.order_note_code = note.code
JOIN
sierra_view.order_status_property_myuser os
ON
o.order_status_code = os.code
JOIN
sierra_view.vendor_record v
ON
o.vendor_record_code = v.code AND o.accounting_unit_code_num = v.accounting_unit_code_num
JOIN
sierra_view.varfield vn
ON
v.id = vn.record_id AND vn.varfield_type_code = 't'
JOIN
sierra_view.accounting_unit a
ON
o.accounting_unit_code_num = a.code_num
JOIN
sierra_view.accounting_unit_myuser an
ON
a.code_num = an.code
JOIN
sierra_view.fund_master fm
ON
cmf.fund_code::NUMERIC = fm.code_num AND fm.accounting_unit_id = a.id
JOIN
sierra_view.fund_property fp
ON
fm.id = fp.fund_master_id AND fp.fund_type_id = '1'
JOIN
sierra_view.fund_property_name fn
ON
fp.id = fn.fund_property_id
--Include to limit results to the contents of a review file containing order records
{{#if include_review_file}}
JOIN
sierra_view.bool_set bs
ON
bs.record_metadata_id = o.id AND bs.bool_info_id = {{review_file}}
{{/if include_review_file}}


WHERE a.code_num = {{accounting_unit}}
--Fill in the number of your desired accounting unit

GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34
