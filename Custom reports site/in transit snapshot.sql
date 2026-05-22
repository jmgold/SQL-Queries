/*
Jeremy Goldstein
Minuteman Library Network
Provides details for items that currently have a status of in transit
*/

SELECT 
  *,
  '' AS "In Transit Snapshot",
  '' AS "https://sic.minlib.net/reports/119"

FROM (
  SELECT
    rm.record_type_code||rm.record_num||'a' AS item_number,
    ip.barcode,
    REPLACE(ip.call_number,'|a','') AS call_number,
    i.location_code AS item_shelving_location,
    b.best_title AS title,
    b.best_author AS author,
    TO_TIMESTAMP(SPLIT_PART(v.field_content,': IN',1), 'Dy Mon DD YYYY  HH:MIAM') AS checkin_time,
    SPLIT_PART(SPLIT_PART(v.field_content,'from ',2),' to',1) AS checkin_stat_group,
    l.name AS destination_library
  
  FROM sierra_view.item_record i
  JOIN sierra_view.varfield v
    ON i.id = v.record_id
    AND v.varfield_type_code = 'm'
    AND v.field_content LIKE '%IN TRANSIT%'
  JOIN sierra_view.location_myuser l
    ON SUBSTRING(SPLIT_PART(v.field_content,'to ',2) FROM 1 FOR 3) = l.code
    AND l.code NOT IN ('trn','mti')
  JOIN sierra_view.record_metadata rm
    ON i.id = rm.id
  JOIN sierra_view.item_record_property ip
    ON i.id = ip.item_record_id
  JOIN sierra_view.bib_record_item_record_link bil
    ON i.id = bil.item_record_id
  JOIN sierra_view.bib_record_property b
    ON bil.bib_record_id = b.bib_record_id  
  
  WHERE i.item_status_code = 't'
    AND {{location_field}} ~ {{location}}
	 /*
	 location_field options are
	   i.location_code
      SPLIT_PART(SPLIT_PART(v.field_content,'from ',2),' to',1) 
      SUBSTRING(SPLIT_PART(v.field_content,'to ',2) FROM 1 FOR 3)
    location will take the form ^oln, which in this example looks for all locations starting with the string oln.'
    */

  ORDER BY 6,3
)a