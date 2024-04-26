/*
Jeremy Goldstein
Minuteman Library Network
*/

SELECT
  rmi.record_type_code||rmi.record_num AS "ItemNum",
  ip.barcode,
  rmb.record_type_code||rmb.record_num AS "BibNum",
  STRING_AGG(SUBSTRING(num.content FROM '[0-9xX]+'),';') FILTER(WHERE num.marc_tag = '020') AS isbn,
  STRING_AGG(num.content,';') FILTER(WHERE num.marc_tag = '022') issn,
  STRING_AGG(SUBSTRING(num.content FROM '[0-9]+'),';') FILTER(WHERE num.marc_tag = '024') AS upc,
  i.icode1,
  i.itype_code_num AS itype,
  it.name AS "ItypeName",
  mp.name AS "MaterialType",
  SUBSTRING(i.location_code,1,3) AS "BranchId",
  TRIM(LEADING '|a' FROM TRIM(ip.call_number)) AS "CallNumber",
  i.location_code,
  loc.name AS location_name,
  TO_CHAR(rmi.creation_date_gmt,'YYYY-MM-DD HH24:MI:SS') AS "CREATED",
  CASE
    WHEN o.id IS NULL THEN isp.name
    ELSE 'CHECKED OUT'
  END AS status,
  TO_CHAR(i.last_checkout_gmt,'YYYY-MM-DD HH24:MI:SS') AS "LOutDate",
  TO_CHAR(o.checkout_gmt,'YYYY-MM-DD HH24:MI:SS') AS "OutDate",
  TO_CHAR(i.last_checkin_gmt,'YYYY-MM-DD HH24:MI:SS') AS "CheckInDate",
  TO_CHAR(o.due_gmt,'YYYY-MM-DD HH24:MI:SS') AS "DueDate",
  i.year_to_date_checkout_total AS "YTDCIRC",
  i.last_year_to_date_checkout_total AS "LYRCIRC",
  i.checkout_total AS "TOT_CHKOUT",
  i.renewal_total AS "TOT_RENEW"
  
FROM
sierra_view.item_record i
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code
JOIN
sierra_view.record_metadata rmi
ON
i.id = rmi.id
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.location_myuser loc
ON
i.location_code = loc.code
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
sierra_view.material_property_myuser mp
ON
bp.material_code = mp.code
LEFT JOIN
sierra_view.subfield num
ON
bp.bib_record_id = num.record_id AND num.marc_tag IN ('020','022','024') AND num.tag = 'a'
JOIN
sierra_view.item_status_property_myuser isp
ON
i.item_status_code = isp.code
LEFT JOIN
sierra_view.checkout o
ON
i.id = o.item_record_id

--use filter for delta file
WHERE rmi.record_last_updated_gmt::DATE = CURRENT_DATE - INTERVAL '1 day'

GROUP BY 1,2,3,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24