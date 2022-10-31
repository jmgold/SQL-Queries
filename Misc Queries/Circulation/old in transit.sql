SELECT
	DISTINCT i.location_code,
	i.barcode,
	TRIM(regexp_replace(iprop.call_number,'\|.',' ','g')),
	bprop.best_author,
	bprop.best_title,
	v.field_content,
	i.itype_code_num,
	it.name
FROM sierra_view.varfield v
	JOIN sierra_view.item_view i ON v.record_id = i.id
	JOIN sierra_view.item_record_property iprop ON i.id = iprop.item_record_id
	JOIN sierra_view.bib_record_item_record_link bilink ON bilink.item_record_id = i.id
	JOIN sierra_view.bib_record_property bprop ON bilink.bib_record_id = bprop.bib_record_id
	JOIN sierra_view.record_metadata ON record_metadata.id = i.id
	JOIN sierra_view.itype_property ip ON i.itype_code_num = ip.code_num
	JOIN sierra_view.itype_property_name it ON ip.id = it.itype_property_id 
WHERE 
	field_content LIKE '%TRANSIT%'
	AND i.item_status_code = 't'
	AND (current_date - record_metadata.record_last_updated_gmt::date) > 14
	AND v.varfield_type_code = 'm'
	AND i.location_code ~ '^"""+libcode.lower()+"""'
ORDER BY 1,3