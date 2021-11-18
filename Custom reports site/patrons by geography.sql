/*
Jeremy Goldstein
Minuteman Library Network

Gathers various patron record statistics grouped on a choice of geography
Census block geoids are stored in patron census fields and can be used to
join results to census data
*/

SELECT
CASE
	WHEN '{{geo}}' = 'zip' THEN SUBSTRING(a.postal_code,'^\d{5}')
	WHEN v.field_content IS NULL THEN 'no data'
	WHEN v.field_content = '' THEN v.field_content
	WHEN '{{geo}}' = 'county' THEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,5)
	WHEN '{{geo}}' = 'tract' THEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,11)
	WHEN '{{geo}}' = 'block group' THEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,12)
END AS geoid,
--Possible options are zip, county, tract, block group
COUNT(DISTINCT p.id) AS total_patrons,
SUM(p.checkout_total) AS total_checkouts,
SUM(p.renewal_total) AS total_renewals,
SUM(p.checkout_total + p.renewal_total) AS total_circ,
SUM(p.checkout_count) AS total_checkouts_current,
COUNT(DISTINCT h.id) AS total_holds_current,
ROUND(AVG(DATE_PART('year',AGE(CURRENT_DATE,p.birth_date_gmt::DATE)))) AS avg_age,
COUNT(DISTINCT p.id) FILTER(WHERE rm.creation_date_gmt::DATE >= {{new_date}}) AS total_new_patrons,
--set date you wish to use for determining if a patron is considered to be new
COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE >= {{active_date}}) AS total_active_patrons,
--set date you wish to use to determine if a patron is considered to be active
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE >= {{active_date}}) AS NUMERIC (12,2))) / CAST(COUNT(DISTINCT p.id) AS NUMERIC (12,2)), 4) ||'%' AS pct_active,
COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100))) as total_blocked_patrons,
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100))) AS NUMERIC (12,2)) / CAST(COUNT(DISTINCT p.id) AS NUMERIC (12,2))),4) ||'%' AS pct_blocked,
ROUND((100.0 * SUM(p.checkout_total))/(100.0 *COUNT(DISTINCT p.id)),2) AS checkouts_per_patron,
CASE
	WHEN '{{geo}}' = 'zip' THEN 'https://censusreporter.org/profiles/86000US'||SUBSTRING(a.postal_code,'^\d{5}')
	WHEN v.field_content IS NULL OR v.field_content = '' THEN 'na'
	WHEN '{{geo}}' = 'county' THEN 'https://censusreporter.org/profiles/05000US'||SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,5)
	WHEN '{{geo}}' = 'tract' THEN 'https://censusreporter.org/profiles/14000US'||SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,11)
	WHEN '{{geo}}' = 'block group' THEN 'https://censusreporter.org/profiles/15000US'||SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,12)
END AS census_reporter_url
FROM
sierra_view.patron_record p
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id
AND a.patron_record_address_type_id = '1'
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id
LEFT JOIN
sierra_view.hold h
ON
p.id = h.patron_record_id
--for census field
LEFT JOIN
sierra_view.varfield v
ON
v.record_id = p.id AND v.varfield_type_code = 'k' AND v.field_content ~ '^\|s25'


WHERE SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ({{tracts}})
--p.ptype_code IN ({{ptype}})

GROUP BY 1,15
ORDER BY 2 DESC
