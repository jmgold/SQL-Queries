/*Jeremy Goldstein
Minuteman Library network

Returns on the fly records that may need to be upgraded
Is passed variables for owning location, created before date, and whether to exclude items attached to an on the fly bib record
*/

SELECT
  *,
  '' AS "ON THE FLY RECORDS",
  '' AS "https://sic.minlib.net/reports/18"
FROM (
  SELECT 
    rm.record_type_code||rm.record_num||'a' AS item_number,
    b.best_title AS title,
    i.location_code AS LOCATION,
    REPLACE(ip.call_number,'|a','') AS call_number,
    v.field_content AS volume,
    ip.barcode,
    rm.creation_date_gmt AS creation_date,
    i.last_checkin_gmt AS last_checkin,
    CASE
	   WHEN o.id IS NOT NULL THEN 'CHECKED OUT'
	   ELSE st.name
    END AS status

  FROM sierra_view.item_record i
  JOIN sierra_view.record_metadata rm
    ON i.id = rm.id
  JOIN sierra_view.item_record_property ip
    ON i.id = ip.item_record_id
  JOIN sierra_view.bib_record_item_record_link l
    ON i.id = l.item_record_id
  JOIN sierra_view.bib_record_property b
    ON l.bib_record_id = b.bib_record_id 
  JOIN sierra_view.item_status_property_myuser st
    ON i.item_status_code = st.code
  LEFT JOIN sierra_view.varfield v
    ON i.id = v.record_id
	 AND v.varfield_type_code = 'v'
  LEFT JOIN sierra_view.checkout o
    ON i.id = o.item_record_id

  WHERE i.item_message_code = 'f'
  AND rm.creation_date_gmt::DATE < {{Created_Date}}
  {{#if Exclude}}
  --exclude items attached to an on the fly bib record
  AND b.best_title NOT LIKE '%fly'
  {{/if Exclude}}
  AND b.best_title NOT LIKE '%MLN ILL%'
  AND i.item_status_code != 'w'
  AND i.location_code ~ {{Location}}
  --location will take the form ^oln, which in this example looks for all locations starting with the string oln.

  ORDER BY 3, 4
)a