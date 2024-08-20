/*
Jeremy Goldstein
Minuteman Library Network
Identifies which libries/accounting units have configured a vendor for edifact ordering
and lists out the relevant vendor codes for each
*/

SELECT
loc.name AS library,
au.code AS accounting_unit,
CASE
   WHEN COUNT(v.*) > 0 THEN TRUE
   ELSE FALSE
END AS uses_edifact,
STRING_AGG(v.code,', ') AS vendors
FROM
sierra_view.location_myuser loc
JOIN
sierra_view.accounting_unit_myuser au
ON
UPPER(loc.code) = au.name
left JOIN
sierra_view.vendor_record v
ON
au.code = v.accounting_unit_code_num AND v.vcode3 = 'd'

WHERE
loc.code ~ '^[a-z]{3}$''
GROUP BY 1,2
ORDER BY 1