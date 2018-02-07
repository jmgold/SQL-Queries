--identifies patron records exhibiting various common data entry errors
SELECT
id2reckey(p.id)||'a' AS record_num,
p.barcode,
p.ptype_code AS ptype,
p.pcode3 AS mass_town,
p.home_library_code,
p.patron_agency_code_num AS agency,
a.addr1 AS street_address,
a.city,
a.postal_code AS zip_code
--opted out of including bad e-mail address in this report
--v.field_content AS email
FROM
sierra_view.patron_view AS p
--JOIN		
--sierra_view.varfield v		
--ON		
--p.id = v.record_id AND varfield_type_code = 'z'
JOIN
sierra_view.patron_record_address as a
ON p.id = a.patron_record_id
WHERE
p.ptype_code = '1'
AND
((p.home_library_code NOT LIKE '%z' AND p.home_library_code IS NOT NULL) --failed to use pickup location code
OR p.pcode3 != '1' --ma town does not match ptype
OR p.patron_agency_code_num = '47' --improperly converted online registration
OR a.addr1 IS NULL
OR a.city IS NULL
OR (a.postal_code !~ '^\d{5}' AND a.postal_code !~'^\d{5}([\-]\d{4})') --zipcode not 5 digits
OR p.barcode is null
OR p.barcode !~ '^\d{14}' --barcode not 14 digits
--or duplicate barcode
--or (v.field_content is not null and v.field_content !~ '(\@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-\.]+$)') --invalid e-mail format
)
ORDER BY
2,1