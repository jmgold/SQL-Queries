SELECT
  rmb.record_type_code||rmb.record_num AS bib_id,
  ip.barcode,
  i.location_code,
  CASE
    WHEN i.checkout_statistic_group_code_num BETWEEN '530' AND '561' THEN sg.name
    WHEN i.checkout_statistic_group_code_num = '0' THEN NULL
    ELSE 'Other'
  END AS checkout_location,
  CASE
    WHEN o.ptype IN ('26','42','43','126','200','201','202','203','204','205','206','207','326') THEN pt.name 
	 WHEN o.ptype IS NULL THEN NULL
	 ELSE 'Other'
  END AS patron_type,
  i.last_checkout_gmt AS last_checkout_date,
  i.checkout_total,
  i.renewal_total,
  --isbn,
  it.name AS item_type,
  CASE
    WHEN o.id IS NOT NULL THEN 'CHECKED OUT'
    ELSE status.name
  END AS status,
  rmi.creation_date_gmt AS creation_date,
  i.price::MONEY AS price,
  ip.call_number,
  STRING_AGG(TRIM(note.field_content), ';') AS notes,
  i.icode1 AS collection_code
  --renewal_date
  
  
  
FROM sierra_view.item_record i
JOIN sierra_view.item_record_property ip
  ON i.id = ip.item_record_id AND i.location_code ~ '^na'
JOIN sierra_view.bib_record_item_record_link l
  ON i.id = l.item_record_id
JOIN sierra_view.record_metadata rmb
  ON l.bib_record_id = rmb.id
JOIN sierra_view.record_metadata rmi
  ON i.id = rmi.id
LEFT JOIN sierra_view.checkout o
  ON i.id = o.item_record_id
LEFT JOIN sierra_view.ptype_property_myuser pt
  ON o.ptype = pt.value
LEFT JOIN sierra_view.statistic_group_myuser sg
  ON i.checkout_statistic_group_code_num = sg.code
JOIN sierra_view.itype_property_myuser it
  ON i.itype_code_num = it.code
JOIN sierra_view.item_status_property_myuser status
  ON i.item_status_code = status.code
LEFT JOIN sierra_view.varfield note
  ON i.id = note.record_id AND note.varfield_type_code = 'x'
  
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,15