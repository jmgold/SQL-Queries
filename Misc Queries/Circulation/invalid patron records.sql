/*
Jeremy Goldstein
Minuteman Library network
Identifies patron records exhibiting various common data entry errors
*/

SELECT
rm.record_type_code||rm.record_num||'a' AS record_num,
b.index_entry AS barcode,
p.ptype_code AS ptype,
p.pcode3 AS mass_town,
p.home_library_code,
p.patron_agency_code_num AS agency,
a.addr1 AS street_address,
a.city,
a.postal_code AS zip_code,
t.phone_number,
u.phone_number AS alt_phont_num
--opted out of including bad e-mail address in this report
--v.field_content AS email
FROM
sierra_view.patron_record p
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id
--join for barcode
LEFT JOIN
sierra_view.phrase_entry b
ON
p.id = b.record_id AND b.index_tag = 'b'
--telephone field
LEFT JOIN
sierra_view.patron_record_phone t
ON
p.id = t.patron_record_id AND t.patron_record_phone_type_id = '1'
--alt telephone field
LEFT JOIN
sierra_view.patron_record_phone u
ON
p.id = u.patron_record_id AND u.patron_record_phone_type_id = '2'
--JOIN		
--sierra_view.varfield v		
--ON		
--p.id = v.record_id AND v.varfield_type_code = 'z'
JOIN
sierra_view.patron_record_address  a
ON p.id = a.patron_record_id
WHERE
--limited by ptype
p.ptype_code = '8'
AND
((p.home_library_code NOT LIKE '%z' AND p.home_library_code IS NOT NULL) --failed to use pickup location code
OR p.pcode3 != '27' --ma town does not match ptype
OR p.patron_agency_code_num = '47' --improperly converted online registration
OR a.addr1 IS NULL
OR a.addr1 !~'^[\dPp]'--address doesn't start with a # or PO
OR a.city IS NULL
OR (a.postal_code !~ '^\d{5}' AND a.postal_code !~'^\d{5}([\-]\d{4})') --zipcode not ##### or #####-####
OR b.index_entry is null
OR b.index_entry !~ '^\d{14}' --barcode not 14 digits
OR (t.phone_number IS NOT NULL AND (t.phone_number !~'^\d{3}[\-]\d{3}[\-]\d{4}' AND t.phone_number !~'^\d{3}[ ]\d{3}[ ]\d{4}')) -- phone not ###-###-#### or ### ### ####
OR (u.phone_number IS NOT NULL AND (u.phone_number !~'^\d{3}[\-]\d{3}[\-]\d{4}' AND u.phone_number !~'^\d{3}[ ]\d{3}[ ]\d{4}')) -- alt phone not ###-###-#### or ### ### ####
--or duplicate barcode
--or (v.field_content is not null and v.field_content !~ '(\@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-\.]+$)') --invalid e-mail format
)
ORDER BY
2,1
