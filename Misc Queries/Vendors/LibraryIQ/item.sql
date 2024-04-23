SELECT
  rmi.record_type_code||rmi.record_num AS "RecordID",
  ip.barcode AS "Barcode",
  rmb.record_type_code||rmb.record_num AS "BibRecordID",
  (SELECT
	COALESCE(STRING_AGG(REGEXP_REPLACE(REPLACE(REGEXP_REPLACE(v.field_content,'(\|a|:)','','g'),'|q',' '),'(\|c|\|2|\|d).*?(\||$)',''),', '),'') AS isbns
	FROM sierra_view.varfield v
	WHERE rmb.id = v.record_id AND v.marc_tag = '020' AND v.field_content !~ '\|z'
  )AS "ISBN",
  (SELECT
	COALESCE(STRING_AGG(REGEXP_REPLACE(REPLACE(REGEXP_REPLACE(v.field_content,'(\|a|:)','','g'),'|q',' '),'(\|c|\|2|\|d).*?(\||$)',''),', '),'') AS isbns
	FROM sierra_view.varfield v
	WHERE rmb.id = v.record_id AND v.marc_tag = '024' AND v.field_content !~ '\|z'
  )AS "UPC",
  i.icode1 AS "Collection code",
  bp.material_code AS "Material type",
  SUBSTRING(i.location_code,1,3) AS "Branch location",
  TRIM(LEADING '|a' FROM TRIM(ip.call_number)) AS "Call number",
  i.location_code AS "Shelf location",
  rmi.creation_date_gmt::DATE AS "ItemCreationDate",
  CASE
    WHEN o.id IS NULL THEN isp.name
    ELSE 'CHECKED OUT'
  END AS "Current item status",
  CASE
    WHEN o.checkout_gmt IS NULL THEN i.last_checkout_gmt::DATE
	 ELSE o.checkout_gmt::DATE
	END AS "Last checkout date",
  i.last_checkin_gmt::DATE AS "Check in date",
  o.due_gmt::DATE AS "Due date",
  i.year_to_date_checkout_total AS "YTD circ count",
  i.checkout_total + i.renewal_total AS "Lifetime circ count"
  
FROM
sierra_view.item_record i
JOIN
sierra_view.record_metadata rmi
ON
i.id = rmi.id
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property bp
ON
l.bib_record_id = bp.bib_record_id
JOIN
sierra_view.record_metadata rmb
ON
l.bib_record_id = rmb.id
JOIN
sierra_view.item_status_property_myuser isp
ON
i.item_status_code = isp.code
LEFT JOIN
sierra_view.checkout o
ON
i.id = o.item_record_id

--use filter for delta file
--WHERE rmi.record_last_updated_gmt::DATE = CURRENT_DATE - INTERVAL '1 day'