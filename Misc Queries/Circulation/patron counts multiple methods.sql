/*
Jeremy Goldstein
Minuteman Library Network

Patron counts at a location broken out by various definitions of local patron
*/

--patrons by ptype assigned to library
SELECT
'ptype' AS grouping,
COUNT(p.id) AS total_count,
COUNT(p.id) FILTER (WHERE p.expiration_date_gmt > NOW()) AS total_not_expired,
COUNT(p.id) FILTER (WHERE p.activity_gmt >= (NOW() - INTERVAL '1 year')) AS total_active_last_year

FROM
sierra_view.patron_record p

WHERE
p.ptype_code = '32'

UNION

--patrons by barcodes starting with prefix used by library
SELECT
'barcode_prefix' AS grouping,
COUNT(p.id) AS total_count,
COUNT(p.id) FILTER (WHERE p.expiration_date_gmt > NOW()) AS total_not_expired,
COUNT(p.id) FILTER (WHERE p.activity_gmt >= (NOW() - INTERVAL '1 year')) AS total_active_last_year

FROM
sierra_view.patron_view p

WHERE
p.barcode LIKE '22051%'

UNION

--Patrons by selected home library
SELECT
'home_library' AS grouping,
COUNT(p.id) AS total_count,
COUNT(p.id) FILTER (WHERE p.expiration_date_gmt > NOW()) AS total_not_expired,
COUNT(p.id) FILTER (WHERE p.activity_gmt >= (NOW() - INTERVAL '1 year')) AS total_active_last_year

FROM
sierra_view.patron_record p

WHERE
p.home_library_code = 'stoz'

UNION

--patrons by assigned agency code
SELECT
'agency' AS grouping,
COUNT(p.id) AS total_count,
COUNT(p.id) FILTER (WHERE p.expiration_date_gmt > NOW()) AS total_not_expired,
COUNT(p.id) FILTER (WHERE p.activity_gmt >= (NOW() - INTERVAL '1 year')) AS total_active_last_year

FROM
sierra_view.patron_record p

WHERE
p.patron_agency_code_num = '34'

UNION

--patrons by residency as coded in pcode3 field
SELECT
'residency' AS grouping,
COUNT(p.id) AS total_count,
COUNT(p.id) FILTER (WHERE p.expiration_date_gmt > NOW()) AS total_not_expired,
COUNT(p.id) FILTER (WHERE p.activity_gmt >= (NOW() - INTERVAL '1 year')) AS total_active_last_year

FROM
sierra_view.patron_record p

WHERE
p.pcode3 = '102'

ORDER BY 1