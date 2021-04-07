/*
Jeremy Goldstein
Minuteman Library Network

Gathers circ transaction counts grouped on a choice of geography.  
Census blocks are present in patron records to enable this report.
Census options can be used to join results to census data
*/

SELECT
CASE
	WHEN v.field_content ~ '^\|s\|c' THEN 'no data'
	ELSE SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,12)
END AS geoid,
i.icode1 AS SCAT,
--Possible options are zip, county, tract, block group
COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'o') AS "5_week_checkout_count",
--COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'o' AND SUBSTRING(t.item_location_code,1,3) ~ '^fp') AS "5_week_local_checkout_count",
--COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'o' AND SUBSTRING(t.item_location_code,1,3) !~ '^fp') AS "5_week_network_checkout_count",
COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'f') AS "5_week_filled_hold_count",
CASE
	WHEN v.field_content IS NULL OR v.field_content = '' THEN 'na'
	ELSE 'https://censusreporter.org/profiles/15000US'||SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,12)
END AS census_reporter_url

FROM
sierra_view.patron_record p
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id
AND a.patron_record_address_type_id = '1'
JOIN
sierra_view.circ_trans t
ON
p.id = t.patron_record_id
--for census field
JOIN
sierra_view.varfield v
ON
v.record_id = p.id AND v.varfield_type_code = 'k' AND v.field_content ~ '^\|s\d{2}'
JOIN
sierra_view.statistic_group_myuser sg
ON
t.stat_group_code_num = sg.code
JOIN
sierra_view.item_record i
ON
t.item_record_id = i.id AND i.location_code ~ '^fp'
/*
JOIN
sierra_view.bib_record_item_record_link l
ON
t.bib_record_id = l.bib_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id AND b.material_code IN ({{mat_type}})
*/

WHERE 
t.stat_group_code_num BETWEEN '360' AND '379'
GROUP BY 1,2,5
ORDER BY 1,2