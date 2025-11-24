/*
Jeremy Goldstein
Minuteman Library Network

Returns details for holds at a pickup location
Filters for pickup location, hold placed date and hold status
*/

SELECT
  *,
  '' AS "Outstanding Holds",
  '' AS "https://sic.minlib.net/reports/60"
  
FROM (
  SELECT
    DISTINCT h.id AS hold_id,
    h.placed_gmt::DATE AS date_placed,
    rmp.record_type_code||rmp.record_num||'a' AS patron_number,
    pn.last_name||', '||pn.first_name||' '||pn.middle_name AS name,
    bp.best_title AS title,
    rm.record_type_code||rm.record_num||'a' AS record_number,
    loc.name AS pickup_location,
    CASE
	   WHEN h.is_frozen = 'true' THEN 'Frozen'
	   WHEN h.status = '0' THEN 'On hold'
	   WHEN h.status = 't' THEN 'In transit'
	   ELSE 'Ready for pickup'
    END AS hold_status,
    CASE
      WHEN rm.record_type_code = 'b' THEN 'bib'
      ELSE 'item'
    END AS hold_type,
    REGEXP_REPLACE(ip.call_number,'\|(a|f)','','g') AS call_number,
    i.location_code AS item_location,
    SPLIT_PART(v.field_content,': ',1) AS in_transit_time,
    tloc.name AS in_transit_origin,
    h.on_holdshelf_gmt::DATE AS on_holdshelf_date,
    h.expire_holdshelf_gmt::DATE AS expire_holdshelf_date

  FROM sierra_view.hold h
  JOIN sierra_view.record_metadata rm
    ON h.record_id = rm.id
  JOIN sierra_view.record_metadata rmp
    ON h.patron_record_id = rmp.id
  JOIN sierra_view.patron_record_fullname pn
    ON h.patron_record_id = pn.patron_record_id
  JOIN sierra_view.bib_record_item_record_link l
    ON h.record_id = l.bib_record_id
    OR h.record_id = l.item_record_id
  JOIN sierra_view.bib_record_property bp
    ON l.bib_record_id = bp.bib_record_id
  JOIN sierra_view.location_myuser loc
    ON SUBSTRING(h.pickup_location_code,1,3) = loc.code
  LEFT JOIN sierra_view.item_record_property ip
    ON h.record_id = ip.item_record_id
  LEFT JOIN sierra_view.item_record i
    ON ip.item_record_id = i.id
  LEFT JOIN sierra_view.varfield v
    ON i.id = v.record_id
    AND v.varfield_type_code = 'm'
    AND v.field_content LIKE '%IN TRANSIT%'
  LEFT JOIN sierra_view.location_myuser tloc
    ON SUBSTRING(SPLIT_PART(SPLIT_PART(v.field_content,'from ',2),' to',1)FROM 1 FOR 3) = tloc.code
  
  WHERE h.placed_gmt BETWEEN {{start_date}}::DATE AND {{end_date}}::DATE
  AND h.pickup_location_code ~ {{location}}
  --location will take the form ^oln, which in this example looks for all locations starting with the string oln.

  ORDER BY 2,1
)inner_query

WHERE inner_query.hold_status IN ({{hold_status}})
--values are 'In transit', 'Ready for pickup', 'On hold', 'Frozen'