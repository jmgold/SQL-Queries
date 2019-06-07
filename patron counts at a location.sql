/*
Jeremy Goldstein
Minuteman Library Network

Patron counts at a location
*/
SELECT
COUNT(p.id) FILTER (WHERE p.ptype_code = '32') AS total_count_ptype,
COUNT(p.id) FILTER (WHERE p.barcode LIKE '22051%') AS total_count_barcode,
COUNT(p.id) FILTER (WHERE p.home_library_code = 'stoz') AS total_count_home_library,
COUNT(p.id) FILTER (WHERE p.ptype_code = '32' AND p.expiration_date_gmt > NOW()) AS total_not_expired_ptype,
COUNT(p.id) FILTER (WHERE p.barcode LIKE '22051%' AND p.expiration_date_gmt > NOW()) AS total_not_expired_barcode,
COUNT(p.id) FILTER (WHERE p.home_library_code = 'stoz' AND p.expiration_date_gmt > NOW()) AS total_not_expired_home_library,
COUNT(p.id) FILTER (WHERE p.ptype_code = '32' AND p.activity_gmt >= NOW() - INTERVAL '1 year') AS total_active_last_year_ptype,
COUNT(p.id) FILTER (WHERE p.barcode LIKE '22051%' AND p.activity_gmt >= NOW() - INTERVAL '1 year') AS total_active_last_year_barcode,
COUNT(p.id) FILTER (WHERE p.home_library_code = 'stoz' AND p.activity_gmt >= NOW() - INTERVAL '1 year') AS total_active_last_year_home_library
FROM
sierra_view.patron_view p
WHERE
p.ptype_code = '32' OR p.barcode LIKE '22051%' OR p.home_library_code = 'stoz'