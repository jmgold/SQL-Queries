/*Jeremy Goldstein
Minuteman Library network

Returns on the fly records that may need to be upgraded
Is passed variables for owning location, created before date, and whether to exclude items attached to an on the fly bib record
*/

select 
id2reckey(i.id)||'a' as "item_number",
b.title as "title",
i.location_code as "location",
REPLACE(ip.call_number,'|a','') AS call_number,
v.field_content AS volume,
i.barcode as "barcode",
i.record_creation_date_gmt as "creation_date",
i.last_checkin_gmt as "last_checkin"
from
sierra_view.item_view as i
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.bib_record_item_record_link           AS link
ON
i.id = link.item_record_id
JOIN
sierra_view.bib_view                             AS b
ON
link.bib_record_id = b.id 
LEFT JOIN
sierra_view.varfield v
ON
i.id = v.record_id AND v.varfield_type_code = 'v'
where
i.item_message_code = 'f'
and
i.record_creation_date_gmt::DATE < {{Created_Date}}
{{#if Exclude}}
--exclude items attached to an on the fly bib record
and b.title not like '%fly'
{{/if Exclude}}
and b.title not like '%MLN ILL%'
AND i.item_status_code != 'w'
AND i.location_code ~ {{location}}
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
order by 3, 4;