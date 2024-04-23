/*
Jeremy Goldstein
Minuteman Library Network
Provides various performance metrics for checkouts over the prior month
*/

SELECT *,
'' AS "CHECKOUT: CHECKOUT LOCATION",
'' AS "https://sic.minlib.net/reports/62"

FROM
(SELECT
{{grouping}},
/*Possible groupings
--it.name AS itype,
--C.icode1::VARCHAR AS scat,
--UPPER(SUBSTRING(C.item_location_code,1,3)) AS owning_location,
--p3.name AS MA_town,
--pt.name AS ptype,
--SG.name AS stat_group,
*/
COUNT(C.id) FILTER(WHERE C.op_code = 'o') AS total_checkouts,
COUNT(C.id) FILTER(WHERE C.op_code = 'f') AS filled_holds,
ROUND(100.0 * CAST(COUNT(C.id) FILTER(WHERE C.op_code = 'f')AS NUMERIC (12,2)) / (COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_holds,
COUNT(C.id) FILTER(WHERE C.item_location_code ~ {{location}} AND C.op_code = 'o') AS local_items,
ROUND(100.0 * (CAST(COUNT(C.id) FILTER(WHERE C.item_location_code ~ {{location}} AND C.op_code = 'o')AS NUMERIC (12,2)) / COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_local,
COUNT(C.id) FILTER(WHERE C.item_location_code !~ {{location}} AND C.op_code = 'o') AS non_local_items,
ROUND(100.0 * (CAST(COUNT(C.id) FILTER(WHERE C.item_location_code !~ {{location}} AND C.op_code = 'o')AS NUMERIC (12,2)) / COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_non_local,
ROUND(100 * (CAST(COUNT(C.id) FILTER(WHERE C.op_code = 'o') AS NUMERIC (12,2)) / 
	(SELECT CAST(COUNT (C.id) as numeric (12,2)) FROM sierra_view.circ_trans C WHERE CASE 
   --location using the form ^act in order to reuse an existing filter
	WHEN  {{location}} = '^ac' THEN (C.stat_group_code_num BETWEEN '100' AND '109' OR C.stat_group_code_num BETWEEN '870' AND '879')
	WHEN  {{location}} = '^act' THEN C.stat_group_code_num BETWEEN '100' AND '109'
	WHEN  {{location}} = '^ac2' THEN C.stat_group_code_num BETWEEN '870' AND '879'
	WHEN  {{location}} = '^arl' THEN (C.stat_group_code_num BETWEEN '110' AND '119' OR C.stat_group_code_num = '996')
	WHEN  {{location}} = '^ar2' THEN C.stat_group_code_num BETWEEN '120' AND '129'
	WHEN  {{location}} = '^ar' THEN (C.stat_group_code_num BETWEEN '110' AND '129' OR C.stat_group_code_num = '996')
	WHEN  {{location}} = '^ash' THEN C.stat_group_code_num BETWEEN '130' AND '139'
	WHEN  {{location}} = '^bed' THEN C.stat_group_code_num BETWEEN '140' AND '149'
	WHEN  {{location}} = '^blm' THEN C.stat_group_code_num BETWEEN '150' AND '179'
	WHEN  {{location}} = '^brk' THEN C.stat_group_code_num BETWEEN '180' AND '189'
	WHEN  {{location}} = '^br2' THEN C.stat_group_code_num BETWEEN '190' AND '199'
	WHEN  {{location}} = '^br3' THEN C.stat_group_code_num BETWEEN '200' AND '209'
	WHEN  {{location}} = '^br' THEN C.stat_group_code_num BETWEEN '180' AND '209'
	WHEN  {{location}} = '^cam' THEN (C.stat_group_code_num BETWEEN '210' AND '219' OR C.stat_group_code_num = '994' OR C.stat_group_code_num = '997') 
	WHEN  {{location}} = '^ca3' THEN C.stat_group_code_num BETWEEN '230' AND '239'
	WHEN  {{location}} = '^ca4' THEN C.stat_group_code_num BETWEEN '240' AND '249'
	WHEN  {{location}} = '^ca5' THEN C.stat_group_code_num BETWEEN '250' AND '259'
	WHEN  {{location}} = '^ca6' THEN C.stat_group_code_num BETWEEN '260' AND '269'
	WHEN  {{location}} = '^ca7' THEN C.stat_group_code_num BETWEEN '270' AND '279'
	WHEN  {{location}} = '^ca8' THEN C.stat_group_code_num BETWEEN '280' AND '289'
	WHEN  {{location}} = '^ca9' THEN C.stat_group_code_num BETWEEN '290' AND '299'
	WHEN  {{location}} = '^ca' THEN (C.stat_group_code_num BETWEEN '210' AND '299' OR C.stat_group_code_num = '994' OR C.stat_group_code_num = '997')
	WHEN  {{location}} = '^con' THEN C.stat_group_code_num BETWEEN '300' AND '309'
	WHEN  {{location}} = '^co2' THEN C.stat_group_code_num BETWEEN '310' AND '319'
	WHEN  {{location}} = '^co' THEN C.stat_group_code_num BETWEEN '300' AND '319'
	WHEN  {{location}} = '^ddm' THEN C.stat_group_code_num BETWEEN '320' AND '329'
	WHEN  {{location}} = '^dd2' THEN C.stat_group_code_num BETWEEN '330' AND '339'
	WHEN  {{location}} = '^dd' THEN C.stat_group_code_num BETWEEN '320' AND '339'
	WHEN  {{location}} = '^dea' THEN C.stat_group_code_num BETWEEN '340' AND '349'
	WHEN  {{location}} = '^dov' THEN C.stat_group_code_num BETWEEN '350' AND '359'
	WHEN  {{location}} = '^fpl' THEN C.stat_group_code_num BETWEEN '360' AND '369'
	WHEN  {{location}} = '^fp3' THEN C.stat_group_code_num = '373'
	WHEN  {{location}} = '^fp2' THEN C.stat_group_code_num BETWEEN '370' AND '379'
	WHEN  {{location}} = '^fp' THEN C.stat_group_code_num BETWEEN '360' AND '379'
	WHEN  {{location}} = '^frk' THEN C.stat_group_code_num BETWEEN '380' AND '389'
	WHEN  {{location}} = '^fst' THEN C.stat_group_code_num BETWEEN '390' AND '399'
	WHEN  {{location}} = '^hol' THEN C.stat_group_code_num BETWEEN '400' AND '409'
	WHEN  {{location}} = '^las' THEN C.stat_group_code_num BETWEEN '410' AND '419'
	WHEN  {{location}} = '^lex' THEN C.stat_group_code_num BETWEEN '420' AND '439'
	WHEN  {{location}} = '^lin' THEN C.stat_group_code_num BETWEEN '440' AND '449'
	WHEN  {{location}} = '^may' THEN C.stat_group_code_num BETWEEN '450' AND '459'
	WHEN  {{location}} = '^med' THEN C.stat_group_code_num BETWEEN '480' AND '489'
	WHEN  {{location}} = '^mil' THEN C.stat_group_code_num BETWEEN '490' AND '499'
	WHEN  {{location}} = '^mld' THEN C.stat_group_code_num BETWEEN '500' AND '509'
	WHEN  {{location}} = '^mwy' THEN C.stat_group_code_num BETWEEN '520' AND '529'
	WHEN  {{location}} = '^na(t|4)' THEN C.stat_group_code_num BETWEEN '530' AND '539' OR C.stat_group_code_num BETWEEN '560' AND '569'
	WHEN  {{location}} = '^na2' THEN C.stat_group_code_num BETWEEN '540' AND '549'
	WHEN  {{location}} = '^na3' THEN C.stat_group_code_num BETWEEN '550' AND '559'
	WHEN  {{location}} = '^na' THEN C.stat_group_code_num BETWEEN '530' AND '559'
	WHEN  {{location}} = '^na[^2]' THEN C.stat_group_code_num BETWEEN '530' AND '539' OR C.stat_group_code_num BETWEEN '550' AND '569'
	WHEN  {{location}} = '^nee' THEN C.stat_group_code_num BETWEEN '570' AND '579'
	WHEN  {{location}} = '^nor' THEN C.stat_group_code_num BETWEEN '580' AND '589'
	WHEN  {{location}} = '^ntn' THEN C.stat_group_code_num BETWEEN '590' AND '599'
	WHEN  {{location}} = '^oln' THEN C.stat_group_code_num BETWEEN '620' AND '629'
	WHEN  {{location}} = '^som' THEN C.stat_group_code_num BETWEEN '640' AND '649'
	WHEN  {{location}} = '^so2' THEN C.stat_group_code_num BETWEEN '650' AND '659'
	WHEN  {{location}} = '^so3' THEN C.stat_group_code_num BETWEEN '660' AND '669'
	WHEN  {{location}} = '^so' THEN C.stat_group_code_num BETWEEN '640' AND '679'
	WHEN  {{location}} = '^sto' THEN C.stat_group_code_num BETWEEN '680' AND '689'
	WHEN  {{location}} = '^sud' THEN C.stat_group_code_num BETWEEN '690' AND '699'
	WHEN  {{location}} = '^wlm' THEN C.stat_group_code_num BETWEEN '700' AND '709' OR C.stat_group_code_num = '993'
	WHEN  {{location}} = '^wa' THEN C.stat_group_code_num BETWEEN '710' AND '739'
	WHEN  {{location}} = '^wa[^4]' THEN C.stat_group_code_num BETWEEN '710' AND '729'
	WHEN  {{location}} = '^wa4' THEN C.stat_group_code_num BETWEEN '730' AND '739'
	WHEN  {{location}} = '^wyl' THEN C.stat_group_code_num BETWEEN '740' AND '749'
	WHEN  {{location}} = '^wel' THEN C.stat_group_code_num BETWEEN '750' AND '759'
	WHEN  {{location}} = '^we2' THEN C.stat_group_code_num BETWEEN '760' AND '769'
	WHEN  {{location}} = '^we3' THEN C.stat_group_code_num BETWEEN '770' AND '779'
	WHEN  {{location}} = '^we' THEN C.stat_group_code_num BETWEEN '750' AND '779'
	WHEN  {{location}} = '^win' THEN C.stat_group_code_num BETWEEN '780' AND '789'
	WHEN  {{location}} = '^wob' THEN C.stat_group_code_num BETWEEN '790' AND '799'
	WHEN  {{location}} = '^wsn' THEN C.stat_group_code_num BETWEEN '800' AND '809'
	WHEN  {{location}} = '^wwd' THEN C.stat_group_code_num BETWEEN '810' AND '819'
	WHEN  {{location}} = '^ww2' THEN C.stat_group_code_num BETWEEN '820' AND '829'
	WHEN  {{location}} = '^ww' THEN C.stat_group_code_num BETWEEN '810' AND '829'
	WHEN  {{location}} = '^pmc' THEN C.stat_group_code_num BETWEEN '830' AND '839'
	WHEN  {{location}} = '^reg' THEN C.stat_group_code_num BETWEEN '840' AND '849'
	WHEN  {{location}} = '^shr' THEN C.stat_group_code_num BETWEEN '850' AND '859'
	WHEN  {{location}} = '\w' THEN C.stat_group_code_num BETWEEN '100' AND '999'
	END AND C.op_code = 'o' AND C.transaction_gmt::DATE {{relative_date}})), 6)||'%' AS relative_checkout_total,
	/*
	relative_date possible values
	= (NOW()::DATE - INTERVAL '1 day') (yesterday)
	BETWEEN (NOW()::DATE - INTERVAL '1 week') AND (NOW()::DATE - INTERVAL '1 day') (last week)
	BETWEEN (NOW()::DATE - INTERVAL '1 month') AND (NOW()::DATE - INTERVAL '1 day') (last month)
	*/
COUNT(DISTINCT C.patron_record_id) AS unique_patrons,
COALESCE(SUM(i.price) FILTER(WHERE C.op_code = 'o'),0)::MONEY AS total_value

FROM
sierra_view.circ_trans C
LEFT JOIN
sierra_view.item_record i
ON
C.item_record_id = i.id
JOIN
sierra_view.itype_property_myuser it
ON
C.itype_code_num = it.code
JOIN
sierra_view.user_defined_pcode3_myuser p3
ON
C.pcode3::VARCHAR = p3.code
JOIN
sierra_view.ptype_property_myuser pt
ON
C.ptype_code = pt.value::VARCHAR
JOIN
sierra_view.statistic_group_myuser sg
ON
C.stat_group_code_num = sg.code

WHERE 
CASE 
	WHEN  {{location}} = '^ac' THEN (C.stat_group_code_num BETWEEN '100' AND '109' OR C.stat_group_code_num BETWEEN '870' AND '879')
	WHEN  {{location}} = '^act' THEN C.stat_group_code_num BETWEEN '100' AND '109'
	WHEN  {{location}} = '^ac2' THEN C.stat_group_code_num BETWEEN '870' AND '879'
	WHEN  {{location}} = '^arl' THEN (C.stat_group_code_num BETWEEN '110' AND '119' OR C.stat_group_code_num = '996')
	WHEN  {{location}} = '^ar2' THEN C.stat_group_code_num BETWEEN '120' AND '129'
	WHEN  {{location}} = '^ar' THEN (C.stat_group_code_num BETWEEN '110' AND '129' OR C.stat_group_code_num = '996')
	WHEN  {{location}} = '^ash' THEN C.stat_group_code_num BETWEEN '130' AND '139'
	WHEN  {{location}} = '^bed' THEN C.stat_group_code_num BETWEEN '140' AND '149'
	WHEN  {{location}} = '^blm' THEN C.stat_group_code_num BETWEEN '150' AND '179'
	WHEN  {{location}} = '^brk' THEN C.stat_group_code_num BETWEEN '180' AND '189'
	WHEN  {{location}} = '^br2' THEN C.stat_group_code_num BETWEEN '190' AND '199'
	WHEN  {{location}} = '^br3' THEN C.stat_group_code_num BETWEEN '200' AND '209'
	WHEN  {{location}} = '^br' THEN C.stat_group_code_num BETWEEN '180' AND '209'
	WHEN  {{location}} = '^cam' THEN (C.stat_group_code_num BETWEEN '210' AND '219' OR C.stat_group_code_num = '994' OR C.stat_group_code_num = '997') 
	WHEN  {{location}} = '^ca3' THEN C.stat_group_code_num BETWEEN '230' AND '239'
	WHEN  {{location}} = '^ca4' THEN C.stat_group_code_num BETWEEN '240' AND '249'
	WHEN  {{location}} = '^ca5' THEN C.stat_group_code_num BETWEEN '250' AND '259'
	WHEN  {{location}} = '^ca6' THEN C.stat_group_code_num BETWEEN '260' AND '269'
	WHEN  {{location}} = '^ca7' THEN C.stat_group_code_num BETWEEN '270' AND '279'
	WHEN  {{location}} = '^ca8' THEN C.stat_group_code_num BETWEEN '280' AND '289'
	WHEN  {{location}} = '^ca9' THEN C.stat_group_code_num BETWEEN '290' AND '299'
	WHEN  {{location}} = '^ca' THEN (C.stat_group_code_num BETWEEN '210' AND '299' OR C.stat_group_code_num = '994' OR C.stat_group_code_num = '997')
	WHEN  {{location}} = '^con' THEN C.stat_group_code_num BETWEEN '300' AND '309'
	WHEN  {{location}} = '^co2' THEN C.stat_group_code_num BETWEEN '310' AND '319'
	WHEN  {{location}} = '^co' THEN C.stat_group_code_num BETWEEN '300' AND '319'
	WHEN  {{location}} = '^ddm' THEN C.stat_group_code_num BETWEEN '320' AND '329'
	WHEN  {{location}} = '^dd2' THEN C.stat_group_code_num BETWEEN '330' AND '339'
	WHEN  {{location}} = '^dd' THEN C.stat_group_code_num BETWEEN '320' AND '339'
	WHEN  {{location}} = '^dea' THEN C.stat_group_code_num BETWEEN '340' AND '349'
	WHEN  {{location}} = '^dov' THEN C.stat_group_code_num BETWEEN '350' AND '359'
	WHEN  {{location}} = '^fpl' THEN C.stat_group_code_num BETWEEN '360' AND '369'
	WHEN  {{location}} = '^fp3' THEN C.stat_group_code_num = '373'
	WHEN  {{location}} = '^fp2' THEN C.stat_group_code_num BETWEEN '370' AND '379'
	WHEN  {{location}} = '^fp' THEN C.stat_group_code_num BETWEEN '360' AND '379'
	WHEN  {{location}} = '^frk' THEN C.stat_group_code_num BETWEEN '380' AND '389'
	WHEN  {{location}} = '^fst' THEN C.stat_group_code_num BETWEEN '390' AND '399'
	WHEN  {{location}} = '^hol' THEN C.stat_group_code_num BETWEEN '400' AND '409'
	WHEN  {{location}} = '^las' THEN C.stat_group_code_num BETWEEN '410' AND '419'
	WHEN  {{location}} = '^lex' THEN C.stat_group_code_num BETWEEN '420' AND '439'
	WHEN  {{location}} = '^lin' THEN C.stat_group_code_num BETWEEN '440' AND '449'
	WHEN  {{location}} = '^may' THEN C.stat_group_code_num BETWEEN '450' AND '459'
	WHEN  {{location}} = '^med' THEN C.stat_group_code_num BETWEEN '480' AND '489'
	WHEN  {{location}} = '^mil' THEN C.stat_group_code_num BETWEEN '490' AND '499'
	WHEN  {{location}} = '^mld' THEN C.stat_group_code_num BETWEEN '500' AND '509'
	WHEN  {{location}} = '^mwy' THEN C.stat_group_code_num BETWEEN '520' AND '529'
	WHEN  {{location}} = '^na(t|4)' THEN C.stat_group_code_num BETWEEN '530' AND '539' OR C.stat_group_code_num BETWEEN '560' AND '569'
	WHEN  {{location}} = '^na2' THEN C.stat_group_code_num BETWEEN '540' AND '549'
	WHEN  {{location}} = '^na3' THEN C.stat_group_code_num BETWEEN '550' AND '559'
	WHEN  {{location}} = '^na' THEN C.stat_group_code_num BETWEEN '530' AND '559'
	WHEN  {{location}} = '^na[^2]' THEN C.stat_group_code_num BETWEEN '530' AND '539' OR C.stat_group_code_num BETWEEN '550' AND '569'
	WHEN  {{location}} = '^nee' THEN C.stat_group_code_num BETWEEN '570' AND '579'
	WHEN  {{location}} = '^nor' THEN C.stat_group_code_num BETWEEN '580' AND '589'
	WHEN  {{location}} = '^ntn' THEN C.stat_group_code_num BETWEEN '590' AND '599'
	WHEN  {{location}} = '^oln' THEN C.stat_group_code_num BETWEEN '620' AND '629'
	WHEN  {{location}} = '^som' THEN C.stat_group_code_num BETWEEN '640' AND '649'
	WHEN  {{location}} = '^so2' THEN C.stat_group_code_num BETWEEN '650' AND '659'
	WHEN  {{location}} = '^so3' THEN C.stat_group_code_num BETWEEN '660' AND '669'
	WHEN  {{location}} = '^so' THEN C.stat_group_code_num BETWEEN '640' AND '679'
	WHEN  {{location}} = '^sto' THEN C.stat_group_code_num BETWEEN '680' AND '689'
	WHEN  {{location}} = '^sud' THEN C.stat_group_code_num BETWEEN '690' AND '699'
	WHEN  {{location}} = '^wlm' THEN C.stat_group_code_num BETWEEN '700' AND '709' OR C.stat_group_code_num = '993'
	WHEN  {{location}} = '^wa' THEN C.stat_group_code_num BETWEEN '710' AND '739'
	WHEN  {{location}} = '^wa[^4]' THEN C.stat_group_code_num BETWEEN '710' AND '729'
	WHEN  {{location}} = '^wa4' THEN C.stat_group_code_num BETWEEN '730' AND '739'
	WHEN  {{location}} = '^wyl' THEN C.stat_group_code_num BETWEEN '740' AND '749'
	WHEN  {{location}} = '^wel' THEN C.stat_group_code_num BETWEEN '750' AND '759'
	WHEN  {{location}} = '^we2' THEN C.stat_group_code_num BETWEEN '760' AND '769'
	WHEN  {{location}} = '^we3' THEN C.stat_group_code_num BETWEEN '770' AND '779'
	WHEN  {{location}} = '^we' THEN C.stat_group_code_num BETWEEN '750' AND '779'
	WHEN  {{location}} = '^win' THEN C.stat_group_code_num BETWEEN '780' AND '789'
	WHEN  {{location}} = '^wob' THEN C.stat_group_code_num BETWEEN '790' AND '799'
	WHEN  {{location}} = '^wsn' THEN C.stat_group_code_num BETWEEN '800' AND '809'
	WHEN  {{location}} = '^wwd' THEN C.stat_group_code_num BETWEEN '810' AND '819'
	WHEN  {{location}} = '^ww2' THEN C.stat_group_code_num BETWEEN '820' AND '829'
	WHEN  {{location}} = '^ww' THEN C.stat_group_code_num BETWEEN '810' AND '829'
	WHEN  {{location}} = '^pmc' THEN C.stat_group_code_num BETWEEN '830' AND '839'
	WHEN  {{location}} = '^reg' THEN C.stat_group_code_num BETWEEN '840' AND '849'
	WHEN  {{location}} = '^shr' THEN C.stat_group_code_num BETWEEN '850' AND '859'
	WHEN  {{location}} = '\w' THEN C.stat_group_code_num BETWEEN '100' AND '999'
	END
AND C.op_code IN ('o','f')
AND C.transaction_gmt::DATE {{relative_date}}

GROUP BY 1

UNION

SELECT
'total' AS total,
COUNT(C.id) FILTER(WHERE C.op_code = 'o') AS total_checkouts,
COUNT(C.id) FILTER(WHERE C.op_code = 'f') AS filled_holds,
ROUND(100.0 * CAST(COUNT(C.id) FILTER(WHERE C.op_code = 'f')AS NUMERIC (12,2)) / (COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_holds,
COUNT(C.id) FILTER(WHERE C.item_location_code ~ {{location}} AND C.op_code = 'o') AS local_items,
ROUND(100.0 * (CAST(COUNT(C.id) FILTER(WHERE C.item_location_code ~ {{location}} AND C.op_code = 'o')AS NUMERIC (12,2)) / COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_local,
COUNT(C.id) FILTER(WHERE C.item_location_code !~ {{location}} AND C.op_code = 'o') AS non_local_items,
ROUND(100.0 * (CAST(COUNT(C.id) FILTER(WHERE C.item_location_code !~ {{location}} AND C.op_code = 'o')AS NUMERIC (12,2)) / COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_non_local,
ROUND(100 * (CAST(COUNT(C.id) FILTER(WHERE C.op_code = 'o') AS NUMERIC (12,2)) / 
	(SELECT CAST(COUNT (C.id) as numeric (12,2)) FROM sierra_view.circ_trans C WHERE CASE 
WHEN  {{location}} = '^ac' THEN (C.stat_group_code_num BETWEEN '100' AND '109' OR C.stat_group_code_num BETWEEN '870' AND '879')
	WHEN  {{location}} = '^act' THEN C.stat_group_code_num BETWEEN '100' AND '109'
	WHEN  {{location}} = '^ac2' THEN C.stat_group_code_num BETWEEN '870' AND '879'
	WHEN  {{location}} = '^arl' THEN (C.stat_group_code_num BETWEEN '110' AND '119' OR C.stat_group_code_num = '996')
	WHEN  {{location}} = '^ar2' THEN C.stat_group_code_num BETWEEN '120' AND '129'
	WHEN  {{location}} = '^ar' THEN (C.stat_group_code_num BETWEEN '110' AND '129' OR C.stat_group_code_num = '996')
	WHEN  {{location}} = '^ash' THEN C.stat_group_code_num BETWEEN '130' AND '139'
	WHEN  {{location}} = '^bed' THEN C.stat_group_code_num BETWEEN '140' AND '149'
	WHEN  {{location}} = '^blm' THEN C.stat_group_code_num BETWEEN '150' AND '179'
	WHEN  {{location}} = '^brk' THEN C.stat_group_code_num BETWEEN '180' AND '189'
	WHEN  {{location}} = '^br2' THEN C.stat_group_code_num BETWEEN '190' AND '199'
	WHEN  {{location}} = '^br3' THEN C.stat_group_code_num BETWEEN '200' AND '209'
	WHEN  {{location}} = '^br' THEN C.stat_group_code_num BETWEEN '180' AND '209'
	WHEN  {{location}} = '^cam' THEN (C.stat_group_code_num BETWEEN '210' AND '219' OR C.stat_group_code_num = '994' OR C.stat_group_code_num = '997') 
	WHEN  {{location}} = '^ca3' THEN C.stat_group_code_num BETWEEN '230' AND '239'
	WHEN  {{location}} = '^ca4' THEN C.stat_group_code_num BETWEEN '240' AND '249'
	WHEN  {{location}} = '^ca5' THEN C.stat_group_code_num BETWEEN '250' AND '259'
	WHEN  {{location}} = '^ca6' THEN C.stat_group_code_num BETWEEN '260' AND '269'
	WHEN  {{location}} = '^ca7' THEN C.stat_group_code_num BETWEEN '270' AND '279'
	WHEN  {{location}} = '^ca8' THEN C.stat_group_code_num BETWEEN '280' AND '289'
	WHEN  {{location}} = '^ca9' THEN C.stat_group_code_num BETWEEN '290' AND '299'
	WHEN  {{location}} = '^ca' THEN (C.stat_group_code_num BETWEEN '210' AND '299' OR C.stat_group_code_num = '994' OR C.stat_group_code_num = '997')
	WHEN  {{location}} = '^con' THEN C.stat_group_code_num BETWEEN '300' AND '309'
	WHEN  {{location}} = '^co2' THEN C.stat_group_code_num BETWEEN '310' AND '319'
	WHEN  {{location}} = '^co' THEN C.stat_group_code_num BETWEEN '300' AND '319'
	WHEN  {{location}} = '^ddm' THEN C.stat_group_code_num BETWEEN '320' AND '329'
	WHEN  {{location}} = '^dd2' THEN C.stat_group_code_num BETWEEN '330' AND '339'
	WHEN  {{location}} = '^dd' THEN C.stat_group_code_num BETWEEN '320' AND '339'
	WHEN  {{location}} = '^dea' THEN C.stat_group_code_num BETWEEN '340' AND '349'
	WHEN  {{location}} = '^dov' THEN C.stat_group_code_num BETWEEN '350' AND '359'
	WHEN  {{location}} = '^fpl' THEN C.stat_group_code_num BETWEEN '360' AND '369'
	WHEN  {{location}} = '^fp3' THEN C.stat_group_code_num = '373'
	WHEN  {{location}} = '^fp2' THEN C.stat_group_code_num BETWEEN '370' AND '379'
	WHEN  {{location}} = '^fp' THEN C.stat_group_code_num BETWEEN '360' AND '379'
	WHEN  {{location}} = '^frk' THEN C.stat_group_code_num BETWEEN '380' AND '389'
	WHEN  {{location}} = '^fst' THEN C.stat_group_code_num BETWEEN '390' AND '399'
	WHEN  {{location}} = '^hol' THEN C.stat_group_code_num BETWEEN '400' AND '409'
	WHEN  {{location}} = '^las' THEN C.stat_group_code_num BETWEEN '410' AND '419'
	WHEN  {{location}} = '^lex' THEN C.stat_group_code_num BETWEEN '420' AND '439'
	WHEN  {{location}} = '^lin' THEN C.stat_group_code_num BETWEEN '440' AND '449'
	WHEN  {{location}} = '^may' THEN C.stat_group_code_num BETWEEN '450' AND '459'
	WHEN  {{location}} = '^med' THEN C.stat_group_code_num BETWEEN '480' AND '489'
	WHEN  {{location}} = '^mil' THEN C.stat_group_code_num BETWEEN '490' AND '499'
	WHEN  {{location}} = '^mld' THEN C.stat_group_code_num BETWEEN '500' AND '509'
	WHEN  {{location}} = '^mwy' THEN C.stat_group_code_num BETWEEN '520' AND '529'
	WHEN  {{location}} = '^na(t|4)' THEN C.stat_group_code_num BETWEEN '530' AND '539' OR C.stat_group_code_num BETWEEN '560' AND '569'
	WHEN  {{location}} = '^na2' THEN C.stat_group_code_num BETWEEN '540' AND '549'
	WHEN  {{location}} = '^na3' THEN C.stat_group_code_num BETWEEN '550' AND '559'
	WHEN  {{location}} = '^na' THEN C.stat_group_code_num BETWEEN '530' AND '559'
	WHEN  {{location}} = '^na[^2]' THEN C.stat_group_code_num BETWEEN '530' AND '539' OR C.stat_group_code_num BETWEEN '550' AND '569'
	WHEN  {{location}} = '^nee' THEN C.stat_group_code_num BETWEEN '570' AND '579'
	WHEN  {{location}} = '^nor' THEN C.stat_group_code_num BETWEEN '580' AND '589'
	WHEN  {{location}} = '^ntn' THEN C.stat_group_code_num BETWEEN '590' AND '599'
	WHEN  {{location}} = '^oln' THEN C.stat_group_code_num BETWEEN '620' AND '629'
	WHEN  {{location}} = '^som' THEN C.stat_group_code_num BETWEEN '640' AND '649'
	WHEN  {{location}} = '^so2' THEN C.stat_group_code_num BETWEEN '650' AND '659'
	WHEN  {{location}} = '^so3' THEN C.stat_group_code_num BETWEEN '660' AND '669'
	WHEN  {{location}} = '^so' THEN C.stat_group_code_num BETWEEN '640' AND '679'
	WHEN  {{location}} = '^sto' THEN C.stat_group_code_num BETWEEN '680' AND '689'
	WHEN  {{location}} = '^sud' THEN C.stat_group_code_num BETWEEN '690' AND '699'
	WHEN  {{location}} = '^wlm' THEN C.stat_group_code_num BETWEEN '700' AND '709' OR C.stat_group_code_num = '993'
	WHEN  {{location}} = '^wa' THEN C.stat_group_code_num BETWEEN '710' AND '739'
	WHEN  {{location}} = '^wa[^4]' THEN C.stat_group_code_num BETWEEN '710' AND '729'
	WHEN  {{location}} = '^wa4' THEN C.stat_group_code_num BETWEEN '730' AND '739'
	WHEN  {{location}} = '^wyl' THEN C.stat_group_code_num BETWEEN '740' AND '749'
	WHEN  {{location}} = '^wel' THEN C.stat_group_code_num BETWEEN '750' AND '759'
	WHEN  {{location}} = '^we2' THEN C.stat_group_code_num BETWEEN '760' AND '769'
	WHEN  {{location}} = '^we3' THEN C.stat_group_code_num BETWEEN '770' AND '779'
	WHEN  {{location}} = '^we' THEN C.stat_group_code_num BETWEEN '750' AND '779'
	WHEN  {{location}} = '^win' THEN C.stat_group_code_num BETWEEN '780' AND '789'
	WHEN  {{location}} = '^wob' THEN C.stat_group_code_num BETWEEN '790' AND '799'
	WHEN  {{location}} = '^wsn' THEN C.stat_group_code_num BETWEEN '800' AND '809'
	WHEN  {{location}} = '^wwd' THEN C.stat_group_code_num BETWEEN '810' AND '819'
	WHEN  {{location}} = '^ww2' THEN C.stat_group_code_num BETWEEN '820' AND '829'
	WHEN  {{location}} = '^ww' THEN C.stat_group_code_num BETWEEN '810' AND '829'
	WHEN  {{location}} = '^pmc' THEN C.stat_group_code_num BETWEEN '830' AND '839'
	WHEN  {{location}} = '^reg' THEN C.stat_group_code_num BETWEEN '840' AND '849'
	WHEN  {{location}} = '^shr' THEN C.stat_group_code_num BETWEEN '850' AND '859'
	WHEN  {{location}} = '\w' THEN C.stat_group_code_num BETWEEN '100' AND '999'
	END AND C.op_code = 'o' AND C.transaction_gmt::DATE {{relative_date}})), 6)||'%' AS relative_checkout_total,
COUNT(DISTINCT C.patron_record_id) AS unique_patrons,
COALESCE(SUM(i.price) FILTER(WHERE C.op_code = 'o'),0)::MONEY AS total_value

FROM
sierra_view.circ_trans C
LEFT JOIN
sierra_view.item_record i
ON
C.item_record_id = i.id
JOIN
sierra_view.itype_property_myuser it
ON
C.itype_code_num = it.code

WHERE 
CASE 
WHEN  {{location}} = '^ac' THEN (C.stat_group_code_num BETWEEN '100' AND '109' OR C.stat_group_code_num BETWEEN '870' AND '879')
	WHEN  {{location}} = '^act' THEN C.stat_group_code_num BETWEEN '100' AND '109'
	WHEN  {{location}} = '^ac2' THEN C.stat_group_code_num BETWEEN '870' AND '879'
	WHEN  {{location}} = '^arl' THEN (C.stat_group_code_num BETWEEN '110' AND '119' OR C.stat_group_code_num = '996')
	WHEN  {{location}} = '^ar2' THEN C.stat_group_code_num BETWEEN '120' AND '129'
	WHEN  {{location}} = '^ar' THEN (C.stat_group_code_num BETWEEN '110' AND '129' OR C.stat_group_code_num = '996')
	WHEN  {{location}} = '^ash' THEN C.stat_group_code_num BETWEEN '130' AND '139'
	WHEN  {{location}} = '^bed' THEN C.stat_group_code_num BETWEEN '140' AND '149'
	WHEN  {{location}} = '^blm' THEN C.stat_group_code_num BETWEEN '150' AND '179'
	WHEN  {{location}} = '^brk' THEN C.stat_group_code_num BETWEEN '180' AND '189'
	WHEN  {{location}} = '^br2' THEN C.stat_group_code_num BETWEEN '190' AND '199'
	WHEN  {{location}} = '^br3' THEN C.stat_group_code_num BETWEEN '200' AND '209'
	WHEN  {{location}} = '^br' THEN C.stat_group_code_num BETWEEN '180' AND '209'
	WHEN  {{location}} = '^cam' THEN (C.stat_group_code_num BETWEEN '210' AND '219' OR C.stat_group_code_num = '994' OR C.stat_group_code_num = '997') 
	WHEN  {{location}} = '^ca3' THEN C.stat_group_code_num BETWEEN '230' AND '239'
	WHEN  {{location}} = '^ca4' THEN C.stat_group_code_num BETWEEN '240' AND '249'
	WHEN  {{location}} = '^ca5' THEN C.stat_group_code_num BETWEEN '250' AND '259'
	WHEN  {{location}} = '^ca6' THEN C.stat_group_code_num BETWEEN '260' AND '269'
	WHEN  {{location}} = '^ca7' THEN C.stat_group_code_num BETWEEN '270' AND '279'
	WHEN  {{location}} = '^ca8' THEN C.stat_group_code_num BETWEEN '280' AND '289'
	WHEN  {{location}} = '^ca9' THEN C.stat_group_code_num BETWEEN '290' AND '299'
	WHEN  {{location}} = '^ca' THEN (C.stat_group_code_num BETWEEN '210' AND '299' OR C.stat_group_code_num = '994' OR C.stat_group_code_num = '997')
	WHEN  {{location}} = '^con' THEN C.stat_group_code_num BETWEEN '300' AND '309'
	WHEN  {{location}} = '^co2' THEN C.stat_group_code_num BETWEEN '310' AND '319'
	WHEN  {{location}} = '^co' THEN C.stat_group_code_num BETWEEN '300' AND '319'
	WHEN  {{location}} = '^ddm' THEN C.stat_group_code_num BETWEEN '320' AND '329'
	WHEN  {{location}} = '^dd2' THEN C.stat_group_code_num BETWEEN '330' AND '339'
	WHEN  {{location}} = '^dd' THEN C.stat_group_code_num BETWEEN '320' AND '339'
	WHEN  {{location}} = '^dea' THEN C.stat_group_code_num BETWEEN '340' AND '349'
	WHEN  {{location}} = '^dov' THEN C.stat_group_code_num BETWEEN '350' AND '359'
	WHEN  {{location}} = '^fpl' THEN C.stat_group_code_num BETWEEN '360' AND '369'
	WHEN  {{location}} = '^fp3' THEN C.stat_group_code_num = '373'
	WHEN  {{location}} = '^fp2' THEN C.stat_group_code_num BETWEEN '370' AND '379'
	WHEN  {{location}} = '^fp' THEN C.stat_group_code_num BETWEEN '360' AND '379'
	WHEN  {{location}} = '^frk' THEN C.stat_group_code_num BETWEEN '380' AND '389'
	WHEN  {{location}} = '^fst' THEN C.stat_group_code_num BETWEEN '390' AND '399'
	WHEN  {{location}} = '^hol' THEN C.stat_group_code_num BETWEEN '400' AND '409'
	WHEN  {{location}} = '^las' THEN C.stat_group_code_num BETWEEN '410' AND '419'
	WHEN  {{location}} = '^lex' THEN C.stat_group_code_num BETWEEN '420' AND '439'
	WHEN  {{location}} = '^lin' THEN C.stat_group_code_num BETWEEN '440' AND '449'
	WHEN  {{location}} = '^may' THEN C.stat_group_code_num BETWEEN '450' AND '459'
	WHEN  {{location}} = '^med' THEN C.stat_group_code_num BETWEEN '480' AND '489'
	WHEN  {{location}} = '^mil' THEN C.stat_group_code_num BETWEEN '490' AND '499'
	WHEN  {{location}} = '^mld' THEN C.stat_group_code_num BETWEEN '500' AND '509'
	WHEN  {{location}} = '^mwy' THEN C.stat_group_code_num BETWEEN '520' AND '529'
	WHEN  {{location}} = '^na(t|4)' THEN C.stat_group_code_num BETWEEN '530' AND '539' OR C.stat_group_code_num BETWEEN '560' AND '569'
	WHEN  {{location}} = '^na2' THEN C.stat_group_code_num BETWEEN '540' AND '549'
	WHEN  {{location}} = '^na3' THEN C.stat_group_code_num BETWEEN '550' AND '559'
	WHEN  {{location}} = '^na' THEN C.stat_group_code_num BETWEEN '530' AND '559'
	WHEN  {{location}} = '^na[^2]' THEN C.stat_group_code_num BETWEEN '530' AND '539' OR C.stat_group_code_num BETWEEN '550' AND '569'
	WHEN  {{location}} = '^nee' THEN C.stat_group_code_num BETWEEN '570' AND '579'
	WHEN  {{location}} = '^nor' THEN C.stat_group_code_num BETWEEN '580' AND '589'
	WHEN  {{location}} = '^ntn' THEN C.stat_group_code_num BETWEEN '590' AND '599'
	WHEN  {{location}} = '^oln' THEN C.stat_group_code_num BETWEEN '620' AND '629'
	WHEN  {{location}} = '^som' THEN C.stat_group_code_num BETWEEN '640' AND '649'
	WHEN  {{location}} = '^so2' THEN C.stat_group_code_num BETWEEN '650' AND '659'
	WHEN  {{location}} = '^so3' THEN C.stat_group_code_num BETWEEN '660' AND '669'
	WHEN  {{location}} = '^so' THEN C.stat_group_code_num BETWEEN '640' AND '679'
	WHEN  {{location}} = '^sto' THEN C.stat_group_code_num BETWEEN '680' AND '689'
	WHEN  {{location}} = '^sud' THEN C.stat_group_code_num BETWEEN '690' AND '699'
	WHEN  {{location}} = '^wlm' THEN C.stat_group_code_num BETWEEN '700' AND '709' OR C.stat_group_code_num = '993'
	WHEN  {{location}} = '^wa' THEN C.stat_group_code_num BETWEEN '710' AND '739'
	WHEN  {{location}} = '^wa[^4]' THEN C.stat_group_code_num BETWEEN '710' AND '729'
	WHEN  {{location}} = '^wa4' THEN C.stat_group_code_num BETWEEN '730' AND '739'
	WHEN  {{location}} = '^wyl' THEN C.stat_group_code_num BETWEEN '740' AND '749'
	WHEN  {{location}} = '^wel' THEN C.stat_group_code_num BETWEEN '750' AND '759'
	WHEN  {{location}} = '^we2' THEN C.stat_group_code_num BETWEEN '760' AND '769'
	WHEN  {{location}} = '^we3' THEN C.stat_group_code_num BETWEEN '770' AND '779'
	WHEN  {{location}} = '^we' THEN C.stat_group_code_num BETWEEN '750' AND '779'
	WHEN  {{location}} = '^win' THEN C.stat_group_code_num BETWEEN '780' AND '789'
	WHEN  {{location}} = '^wob' THEN C.stat_group_code_num BETWEEN '790' AND '799'
	WHEN  {{location}} = '^wsn' THEN C.stat_group_code_num BETWEEN '800' AND '809'
	WHEN  {{location}} = '^wwd' THEN C.stat_group_code_num BETWEEN '810' AND '819'
	WHEN  {{location}} = '^ww2' THEN C.stat_group_code_num BETWEEN '820' AND '829'
	WHEN  {{location}} = '^ww' THEN C.stat_group_code_num BETWEEN '810' AND '829'
	WHEN  {{location}} = '^pmc' THEN C.stat_group_code_num BETWEEN '830' AND '839'
	WHEN  {{location}} = '^reg' THEN C.stat_group_code_num BETWEEN '840' AND '849'
	WHEN  {{location}} = '^shr' THEN C.stat_group_code_num BETWEEN '850' AND '859'
	WHEN  {{location}} = '\w' THEN C.stat_group_code_num BETWEEN '100' AND '999'
END
AND C.op_code IN ('o','f')
AND C.transaction_gmt::DATE {{relative_date}}

ORDER BY 1
)a