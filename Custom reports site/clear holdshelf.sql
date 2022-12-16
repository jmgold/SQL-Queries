SELECT
--use pickup alias if there is one, otherwise name
CASE
	WHEN v.field_content IS NOT NULL THEN v.field_content
	ELSE TRIM(CONCAT(pn.last_name,', ',pn.first_name,' ',pn.middle_name))
END AS patron,
b.best_title AS title,
REGEXP_REPLACE(ip.call_number,'^\|a','') AS call_number,
ip.barcode,
h.placed_gmt::DATE AS date_placed,
TO_CHAR(h.removed_gmt, 'YYYY-MM-DD HH24:MI:SS') AS removed_time,
CASE
	WHEN h.holdshelf_status = 'c' THEN 'Cancelled'
	ELSE 'Expired'
END AS reason

FROM
sierra_view.hold_removed h
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.item_record_id
JOIN
sierra_view.patron_record_fullname pn
ON
h.patron_record_id = pn.patron_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.item_record_property ip
ON
l.item_record_id = ip.item_record_id
LEFT JOIN
sierra_view.varfield v
ON
h.patron_record_id = v.record_id AND v.varfield_type_code = 'v'

WHERE
h.removed_gmt::DATE = {{date_cleared}}
AND h.pickup_location_code ~ {{location}}
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
AND (h.removed_by_program = 'clearholdshelf' OR h.holdshelf_status = 'c')

ORDER BY 1