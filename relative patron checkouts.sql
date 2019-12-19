/*
Jeremy Goldstein
Minuteman Library network

Provides relative checkout counts by ptype and number of those patrons
*/

SELECT
pt.name AS ptype,
COUNT(p.id) AS total_patrons,
SUM(p.checkout_total) AS total_checkouts,
COUNT(p.id) FILTER (WHERE p.activity_gmt > NOW()::DATE - INTERVAL '1 year') total_patrons_active,
SUM(p.checkout_total) FILTER (WHERE p.activity_gmt > NOW()::DATE - INTERVAL '1 year') AS total_checkouts_active,
round(100.0 * (cast(COUNT(p.id) as numeric (12,2)) / (select cast(COUNT (p.id) as numeric (12,2)) from sierra_view.patron_record p WHERE p.ptype_code NOT IN ('0','19','25','169','204','205','206','207','230','231','232','254','255'))), 6)||'%' as relative_patron_total,
round(100.0 * (cast(SUM(p.checkout_total) as numeric (12,2)) / (select cast(SUM(p.checkout_total) as numeric (12,2)) from sierra_view.patron_record p WHERE p.ptype_code NOT IN ('0','19','25','169','204','205','206','207','230','231','232','254','255'))), 6)||'%' as relative_checkout_total,
round(100.0 * (cast(SUM(p.checkout_total) as numeric (12,2)) / (select cast(SUM(p.checkout_total) as numeric (12,2)) from sierra_view.patron_record p WHERE p.ptype_code NOT IN ('0','19','25','169','204','205','206','207','230','231','232','254','255'))), 6)-round(100.0 * (cast(COUNT(p.id) as numeric (12,2)) / (select cast(COUNT (p.id) as numeric (12,2)) from sierra_view.patron_record p WHERE p.ptype_code NOT IN ('0','19','25','169','204','205','206','207','230','231','232','254','255'))), 6)||'%' AS difference,
round(100.0 * (cast(COUNT(p.id) FILTER (WHERE p.activity_gmt > NOW()::DATE - INTERVAL '1 year') as numeric (12,2)) / (select cast(COUNT (p.id) FILTER (WHERE p.activity_gmt > NOW()::DATE - INTERVAL '1 year') as numeric (12,2)) from sierra_view.patron_record p WHERE p.ptype_code NOT IN ('0','19','25','169','204','205','206','207','230','231','232','254','255'))), 6)||'%' as relative_patron_total_active,
round(100.0 * (cast(SUM(p.checkout_total) FILTER (WHERE p.activity_gmt > NOW()::DATE - INTERVAL '1 year') as numeric (12,2)) / (select cast(SUM(p.checkout_total) FILTER (WHERE p.activity_gmt > NOW()::DATE - INTERVAL '1 year') as numeric (12,2)) from sierra_view.patron_record p WHERE p.ptype_code NOT IN ('0','19','25','169','204','205','206','207','230','231','232','254','255'))), 6)||'%' as relative_checkout_total_active,
round(100.0 * (cast(SUM(p.checkout_total) FILTER (WHERE p.activity_gmt > NOW()::DATE - INTERVAL '1 year') as numeric (12,2)) / (select cast(SUM(p.checkout_total) FILTER (WHERE p.activity_gmt > NOW()::DATE - INTERVAL '1 year') as numeric (12,2)) from sierra_view.patron_record p WHERE p.ptype_code NOT IN ('0','19','25','169','204','205','206','207','230','231','232','254','255'))), 6)-round(100.0 * (cast(COUNT(p.id) FILTER (WHERE p.activity_gmt > NOW()::DATE - INTERVAL '1 year') as numeric (12,2)) / (select cast(COUNT (p.id) FILTER (WHERE p.activity_gmt > NOW()::DATE - INTERVAL '1 year') as numeric (12,2)) from sierra_view.patron_record p WHERE p.ptype_code NOT IN ('0','19','25','169','204','205','206','207','230','231','232','254','255'))), 6)||'%' AS difference_active
FROM
sierra_view.patron_record p
JOIN
sierra_view.ptype_property_myuser pt
ON
p.ptype_code = pt.value AND p.ptype_code NOT IN ('0','19','25','169','204','205','206','207','230','231','232','254','255')

GROUP BY 1
ORDER BY 1