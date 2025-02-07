/*
Jeremy Goldstein
Minuteman Library Network

Gathers circ transaction counts grouped on a choice of geography.  
Census blocks are present in patron records to enable this report.
Census options can be used to join results to census data
*/

SELECT
*,
'' AS "TRANSACTIONS BY TRANSACTION LOCATION",
'' AS "https://sic.minlib.net/reports/85"
FROM
(
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
COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'i') AS "5_week_checkin_count",
COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'i' AND t.due_date_gmt::DATE > t.transaction_gmt::DATE) AS "5_week_overdue_checkin",
ROUND(100.0 * (CAST(COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'i' AND t.due_date_gmt::DATE > t.transaction_gmt::DATE) AS NUMERIC (12,2))) / NULLIF(CAST(COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'i') AS NUMERIC (12,2)),0), 4) ||'%' AS pct_overdue_checkin,
COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'o') AS "5_week_checkout_count",
COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'o' AND SUBSTRING(t.item_location_code,1,3) ~ {{location}}) AS "5_week_local_checkout_count",
COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'o' AND SUBSTRING(t.item_location_code,1,3) !~ {{location}}) AS "5_week_network_checkout_count",
COUNT(DISTINCT t.id) FILTER(WHERE t.op_code = 'f') AS "5_week_filled_hold_count",
COUNT(DISTINCT t.patron_record_id) FILTER(WHERE t.op_code = 'o') AS "5_week_unique_patron_checkout_count",
COUNT(DISTINCT t.patron_record_id) FILTER(WHERE t.op_code = 'i') AS "5_week_unique_patron_checkin_count",
COUNT(DISTINCT t.patron_record_id) FILTER(WHERE t.op_code = 'f') AS "5_week_unique_patron_filled_hold_count",
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
sierra_view.circ_trans t
ON
p.id = t.patron_record_id
--for census field
LEFT JOIN
sierra_view.varfield v
ON
v.record_id = p.id AND v.varfield_type_code = 'k' AND v.field_content ~ '^\|s\d{2}'
JOIN
sierra_view.statistic_group_myuser sg
ON
t.stat_group_code_num = sg.code
JOIN
sierra_view.bib_record_item_record_link l
ON
t.bib_record_id = l.bib_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id AND b.material_code IN ({{mat_type}})

WHERE 
CASE
	--location using the form ^act in order to reuse an existing filter
	WHEN  {{location}} = '^ac' THEN (t.stat_group_code_num BETWEEN '100' AND '109' OR t.stat_group_code_num BETWEEN '870' AND '879')
	WHEN  {{location}} = '^act' THEN t.stat_group_code_num BETWEEN '100' AND '109'
	WHEN  {{location}} = '^ac2' THEN t.stat_group_code_num BETWEEN '870' AND '879'
	WHEN  {{location}} = '^arl' THEN (t.stat_group_code_num BETWEEN '110' AND '119' OR t.stat_group_code_num = '996')
	WHEN  {{location}} = '^ar2' THEN t.stat_group_code_num BETWEEN '120' AND '129'
	WHEN  {{location}} = '^ar' THEN (t.stat_group_code_num BETWEEN '110' AND '129' OR t.stat_group_code_num = '996')
	WHEN  {{location}} = '^ash' THEN t.stat_group_code_num BETWEEN '130' AND '139'
	WHEN  {{location}} = '^bed' THEN t.stat_group_code_num BETWEEN '140' AND '149'
	WHEN  {{location}} = '^blm' THEN t.stat_group_code_num BETWEEN '150' AND '179'
	WHEN  {{location}} = '^brk' THEN t.stat_group_code_num BETWEEN '180' AND '189'
	WHEN  {{location}} = '^br2' THEN t.stat_group_code_num BETWEEN '190' AND '199'
	WHEN  {{location}} = '^br3' THEN t.stat_group_code_num BETWEEN '200' AND '209'
	WHEN  {{location}} = '^br' THEN t.stat_group_code_num BETWEEN '180' AND '209'
	WHEN  {{location}} = '^cam' THEN (t.stat_group_code_num BETWEEN '210' AND '219' OR t.stat_group_code_num = '994' OR t.stat_group_code_num = '997') 
	WHEN  {{location}} = '^ca3' THEN t.stat_group_code_num BETWEEN '230' AND '239'
	WHEN  {{location}} = '^ca4' THEN t.stat_group_code_num BETWEEN '240' AND '249'
	WHEN  {{location}} = '^ca5' THEN t.stat_group_code_num BETWEEN '250' AND '259'
	WHEN  {{location}} = '^ca6' THEN t.stat_group_code_num BETWEEN '260' AND '269'
	WHEN  {{location}} = '^ca7' THEN t.stat_group_code_num BETWEEN '270' AND '279'
	WHEN  {{location}} = '^ca8' THEN t.stat_group_code_num BETWEEN '280' AND '289'
	WHEN  {{location}} = '^ca9' THEN t.stat_group_code_num BETWEEN '290' AND '299'
	WHEN  {{location}} = '^ca' THEN (t.stat_group_code_num BETWEEN '210' AND '299' OR t.stat_group_code_num = '994' OR t.stat_group_code_num = '997')
	WHEN  {{location}} = '^con' THEN t.stat_group_code_num BETWEEN '300' AND '309'
	WHEN  {{location}} = '^co2' THEN t.stat_group_code_num BETWEEN '310' AND '319'
	WHEN  {{location}} = '^co' THEN t.stat_group_code_num BETWEEN '300' AND '319'
	WHEN  {{location}} = '^ddm' THEN t.stat_group_code_num BETWEEN '320' AND '329'
	WHEN  {{location}} = '^dd2' THEN t.stat_group_code_num BETWEEN '330' AND '339'
	WHEN  {{location}} = '^dd' THEN t.stat_group_code_num BETWEEN '320' AND '339'
	WHEN  {{location}} = '^dea' THEN t.stat_group_code_num BETWEEN '340' AND '349'
	WHEN  {{location}} = '^dov' THEN t.stat_group_code_num BETWEEN '350' AND '359'
	WHEN  {{location}} = '^fpl' THEN t.stat_group_code_num BETWEEN '360' AND '369'
	WHEN  {{location}} = '^fp3' THEN t.stat_group_code_num = '373'
	WHEN  {{location}} = '^fp2' THEN t.stat_group_code_num BETWEEN '370' AND '379'
	WHEN  {{location}} = '^fp' THEN t.stat_group_code_num BETWEEN '360' AND '379'
	WHEN  {{location}} = '^frk' THEN t.stat_group_code_num BETWEEN '380' AND '389'
	WHEN  {{location}} = '^fst' THEN t.stat_group_code_num BETWEEN '390' AND '399'
	WHEN  {{location}} = '^hol' THEN t.stat_group_code_num BETWEEN '400' AND '409'
	WHEN  {{location}} = '^las' THEN t.stat_group_code_num BETWEEN '410' AND '419'
	WHEN  {{location}} = '^lex' THEN t.stat_group_code_num BETWEEN '420' AND '439'
	WHEN  {{location}} = '^lin' THEN t.stat_group_code_num BETWEEN '440' AND '449'
	WHEN  {{location}} = '^may' THEN t.stat_group_code_num BETWEEN '450' AND '459'
	WHEN  {{location}} = '^med' THEN t.stat_group_code_num BETWEEN '480' AND '489'
	WHEN  {{location}} = '^mil' THEN t.stat_group_code_num BETWEEN '490' AND '499'
	WHEN  {{location}} = '^mld' THEN t.stat_group_code_num BETWEEN '500' AND '509'
	WHEN  {{location}} = '^mwy' THEN t.stat_group_code_num BETWEEN '520' AND '529'
	WHEN  {{location}} = '^na(t|4)' THEN t.stat_group_code_num BETWEEN '530' AND '539' OR t.stat_group_code_num BETWEEN '560' AND '569'
	WHEN  {{location}} = '^na2' THEN t.stat_group_code_num BETWEEN '540' AND '549'
	WHEN  {{location}} = '^na3' THEN t.stat_group_code_num BETWEEN '550' AND '559'
	WHEN  {{location}} = '^na' THEN t.stat_group_code_num BETWEEN '530' AND '569'
	WHEN  {{location}} = '^na[^2]' THEN t.stat_group_code_num BETWEEN '530' AND '539' OR t.stat_group_code_num BETWEEN '550' AND '569'
	WHEN  {{location}} = '^nee' THEN t.stat_group_code_num BETWEEN '570' AND '579'
	WHEN  {{location}} = '^nor' THEN t.stat_group_code_num BETWEEN '580' AND '589'
	WHEN  {{location}} = '^ntn' THEN t.stat_group_code_num BETWEEN '590' AND '599'
	WHEN  {{location}} = '^oln' THEN t.stat_group_code_num BETWEEN '620' AND '629'
	WHEN  {{location}} = '^som' THEN t.stat_group_code_num BETWEEN '640' AND '649'
	WHEN  {{location}} = '^so2' THEN t.stat_group_code_num BETWEEN '650' AND '659'
	WHEN  {{location}} = '^so3' THEN t.stat_group_code_num BETWEEN '660' AND '669'
	WHEN  {{location}} = '^so' THEN t.stat_group_code_num BETWEEN '640' AND '679'
	WHEN  {{location}} = '^sto' THEN t.stat_group_code_num BETWEEN '680' AND '689'
	WHEN  {{location}} = '^sud' THEN t.stat_group_code_num BETWEEN '690' AND '699'
	WHEN  {{location}} = '^wlm' THEN t.stat_group_code_num BETWEEN '700' AND '709' OR t.stat_group_code_num = '993'
	WHEN  {{location}} = '^wl2' THEN t.stat_group_code_num = '981'
	WHEN  {{location}} = '^wl' THEN t.stat_group_code_num BETWEEN '700' AND '709' OR t.stat_group_code_num IN ('993','981')
	WHEN  {{location}} = '^wa' THEN t.stat_group_code_num BETWEEN '710' AND '739'
	WHEN  {{location}} = '^wa[^4]' THEN t.stat_group_code_num BETWEEN '710' AND '729'
	WHEN  {{location}} = '^wa4' THEN t.stat_group_code_num BETWEEN '730' AND '739'
	WHEN  {{location}} = '^wyl' THEN t.stat_group_code_num BETWEEN '740' AND '749'
	WHEN  {{location}} = '^wel' THEN t.stat_group_code_num BETWEEN '750' AND '759'
	WHEN  {{location}} = '^we2' THEN t.stat_group_code_num BETWEEN '760' AND '769'
	WHEN  {{location}} = '^we3' THEN t.stat_group_code_num BETWEEN '770' AND '779'
	WHEN  {{location}} = '^we' THEN t.stat_group_code_num BETWEEN '750' AND '779'
	WHEN  {{location}} = '^win' THEN t.stat_group_code_num BETWEEN '780' AND '789'
	WHEN  {{location}} = '^wob' THEN t.stat_group_code_num BETWEEN '790' AND '799'
	WHEN  {{location}} = '^wsn' THEN t.stat_group_code_num BETWEEN '800' AND '809'
	WHEN  {{location}} = '^wwd' THEN t.stat_group_code_num BETWEEN '810' AND '819'
	WHEN  {{location}} = '^ww2' THEN t.stat_group_code_num BETWEEN '820' AND '829'
	WHEN  {{location}} = '^ww2' THEN t.stat_group_code_num = '831'
	WHEN  {{location}} = '^ww' THEN t.stat_group_code_num BETWEEN '810' AND '829' OR t.stat_group_code_num = '831'
	WHEN  {{location}} = '^reg' THEN t.stat_group_code_num BETWEEN '840' AND '849'
	WHEN  {{location}} = '^shr' THEN t.stat_group_code_num BETWEEN '850' AND '859'
END
GROUP BY 1,12
ORDER BY 2 DESC
)a