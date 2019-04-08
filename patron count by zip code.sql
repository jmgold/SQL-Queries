--Jeremy Goldstein
--Minuteman Library Network

--Produces data for Tableau map

SELECT
a.postal_code,
COUNT(DISTINCT a.patron_record_id) AS total_patrons,
COUNT(DISTINCT a.patron_record_id) FILTER (WHERE p.expiration_date_gmt > NOW()) AS total_non_expired,
COUNT(DISTINCT a.patron_record_id) FILTER (WHERE p.activity_gmt >= NOW() - INTERVAL '6 months') AS total_6mo_active,
COUNT(DISTINCT a.patron_record_id) FILTER (WHERE p.activity_gmt >= NOW() - INTERVAL '12 months') AS total_1yr_active
FROM
sierra_view.patron_record_address a
JOIN
sierra_view.patron_record p
ON
a.patron_record_id = p.id
AND p.ptype_code NOT IN ('9','13','16','19','25','43','44','45','116','159','163','166','169','175','194','195','200','201','202','203','204','205','206','207','254','255')
GROUP BY 1
HAVING COUNT(DISTINCT a.patron_record_id) FILTER (WHERE p.activity_gmt >= NOW() - INTERVAL '1 year') > 200
ORDER BY 4