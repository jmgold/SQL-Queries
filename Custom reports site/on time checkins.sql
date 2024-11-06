/*
Jeremy Goldstein
Minuteman Library Network

Gathers on time and overdue checkins for all items returned to a given location in the past month
*/

WITH checkout_location AS 
(
SELECT
C.id,
CASE
WHEN C.loanrule_code_num BETWEEN 2 AND 12 OR C.loanrule_code_num BETWEEN 501 AND 509 THEN 'ac'
WHEN C.loanrule_code_num BETWEEN 13 AND 23 OR C.loanrule_code_num BETWEEN 510 AND 518 THEN 'ar'
WHEN C.loanrule_code_num BETWEEN 24 AND 34 OR C.loanrule_code_num BETWEEN 519 AND 527 THEN 'as'
WHEN C.loanrule_code_num BETWEEN 35 AND 45 OR C.loanrule_code_num BETWEEN 528 AND 536 THEN 'be'
WHEN C.loanrule_code_num BETWEEN 46 AND 56 OR C.loanrule_code_num BETWEEN 537 AND 545 THEN 'bl'
WHEN C.loanrule_code_num BETWEEN 57 AND 67 OR C.loanrule_code_num BETWEEN 546 AND 554 THEN 'br'
WHEN C.loanrule_code_num BETWEEN 68 AND 78 OR C.loanrule_code_num BETWEEN 555 AND 563 THEN 'ca'
WHEN C.loanrule_code_num BETWEEN 79 AND 89 OR C.loanrule_code_num BETWEEN 564 AND 572 THEN 'co'
WHEN C.loanrule_code_num BETWEEN 90 AND 100 OR C.loanrule_code_num BETWEEN 573 AND 581 THEN 'dd'
WHEN C.loanrule_code_num BETWEEN 101 AND 111 OR C.loanrule_code_num BETWEEN 582 AND 590 THEN 'de'
WHEN C.loanrule_code_num BETWEEN 112 AND 122 OR C.loanrule_code_num BETWEEN 591 AND 599 THEN 'do'
WHEN C.loanrule_code_num BETWEEN 123 AND 133 OR C.loanrule_code_num BETWEEN 600 AND 608 THEN 'fp'
WHEN C.loanrule_code_num BETWEEN 134 AND 144 OR C.loanrule_code_num BETWEEN 609 AND 617 THEN 'fr'
WHEN C.loanrule_code_num BETWEEN 145 AND 155 OR C.loanrule_code_num BETWEEN 618 AND 626 THEN 'fs'
WHEN C.loanrule_code_num BETWEEN 156 AND 166 OR C.loanrule_code_num BETWEEN 627 AND 635 THEN 'ho'
WHEN C.loanrule_code_num BETWEEN 167 AND 177 OR C.loanrule_code_num BETWEEN 636 AND 644 THEN 'la'
WHEN C.loanrule_code_num BETWEEN 178 AND 188 OR C.loanrule_code_num BETWEEN 645 AND 653 THEN 'le'
WHEN C.loanrule_code_num BETWEEN 189 AND 199 OR C.loanrule_code_num BETWEEN 654 AND 662 THEN 'li'
WHEN C.loanrule_code_num BETWEEN 200 AND 210 OR C.loanrule_code_num BETWEEN 663 AND 671 THEN 'ma'
WHEN C.loanrule_code_num BETWEEN 222 AND 232 OR C.loanrule_code_num BETWEEN 681 AND 689 THEN 'me'
WHEN C.loanrule_code_num BETWEEN 233 AND 243 OR C.loanrule_code_num BETWEEN 690 AND 698 THEN 'mi'
WHEN C.loanrule_code_num BETWEEN 244 AND 254 OR C.loanrule_code_num BETWEEN 699 AND 707 THEN 'ml'
WHEN C.loanrule_code_num BETWEEN 266 AND 276 OR C.loanrule_code_num BETWEEN 717 AND 725 THEN 'mw'
WHEN C.loanrule_code_num BETWEEN 277 AND 287 OR C.loanrule_code_num BETWEEN 726 AND 733 THEN 'na'
WHEN C.loanrule_code_num BETWEEN 289 AND 298 OR C.loanrule_code_num BETWEEN 734 AND 743 THEN 'ol'
WHEN C.loanrule_code_num BETWEEN 299 AND 309 OR C.loanrule_code_num BETWEEN 744 AND 752 THEN 'ne'
WHEN C.loanrule_code_num BETWEEN 310 AND 320 OR C.loanrule_code_num BETWEEN 753 AND 761 THEN 'no'
WHEN C.loanrule_code_num BETWEEN 321 AND 331 OR C.loanrule_code_num BETWEEN 762 AND 770 THEN 'nt'
WHEN C.loanrule_code_num BETWEEN 332 AND 342 OR C.loanrule_code_num BETWEEN 771 AND 779 THEN 'so'
WHEN C.loanrule_code_num BETWEEN 343 AND 353 OR C.loanrule_code_num BETWEEN 780 AND 788 THEN 'st'
WHEN C.loanrule_code_num BETWEEN 354 AND 364 OR C.loanrule_code_num BETWEEN 789 AND 797 THEN 'su'
WHEN C.loanrule_code_num BETWEEN 365 AND 375 OR C.loanrule_code_num BETWEEN 798 AND 806 THEN 'wa'
WHEN C.loanrule_code_num BETWEEN 376 AND 386 OR C.loanrule_code_num BETWEEN 807 AND 815 THEN 'we'
WHEN C.loanrule_code_num BETWEEN 387 AND 397 OR C.loanrule_code_num BETWEEN 816 AND 824 THEN 'wi'
WHEN C.loanrule_code_num BETWEEN 398 AND 408 OR C.loanrule_code_num BETWEEN 825 AND 833 THEN 'wl'
WHEN C.loanrule_code_num BETWEEN 409 AND 419 OR C.loanrule_code_num BETWEEN 834 AND 842 THEN 'wo'
WHEN C.loanrule_code_num BETWEEN 420 AND 430 OR C.loanrule_code_num BETWEEN 843 AND 851 THEN 'ws'
WHEN C.loanrule_code_num BETWEEN 431 AND 441 OR C.loanrule_code_num BETWEEN 852 AND 860 THEN 'ww'
WHEN C.loanrule_code_num BETWEEN 442 AND 452 OR C.loanrule_code_num BETWEEN 861 AND 869 THEN 'wy'
WHEN C.loanrule_code_num BETWEEN 453 AND 463 OR C.loanrule_code_num BETWEEN 870 AND 878 THEN 'pm'
WHEN C.loanrule_code_num BETWEEN 464 AND 474 OR C.loanrule_code_num BETWEEN 879 AND 887 THEN 're'
WHEN C.loanrule_code_num BETWEEN 475 AND 485 OR C.loanrule_code_num BETWEEN 888 AND 896 THEN 'sh'
Else 'Other'
END AS checkout_location

FROM
sierra_view.circ_trans C
JOIN
sierra_view.statistic_group_myuser s
ON
C.stat_group_code_num = s.code
)


SELECT
*,
'' AS "ON TIME CHECKINS",
'' AS "https://sic.minlib.net/reports/93"
FROM(
SELECT
{{grouping}}
/*grouping options are
sg.name
it.name
l.name
mat.name
*/ 
AS grouping,
COUNT(t.id) AS total_checkins,
COUNT(t.id) FILTER (WHERE t.due_date_gmt::DATE - t.transaction_gmt::DATE > 1) AS returned_greater_than_1_day_early,
COUNT(t.id) FILTER (WHERE t.due_date_gmt::DATE - t.transaction_gmt::DATE = 1) AS returned_1_day_early,
COUNT(t.id) FILTER (WHERE t.due_date_gmt::DATE = t.transaction_gmt::DATE) AS returned_on_time,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE = 1) AS returned_1_day_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE BETWEEN 2 AND 7) AS returned_2_to_7_days_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE BETWEEN 8 AND 14) AS returned_8_to_14_days_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE BETWEEN 15 AND 21) AS returned_15_to_21_days_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE > 21) AS returned_greater_than_21_days_late
FROM
sierra_view.circ_trans t
JOIN
sierra_view.statistic_group_myuser sg
ON
t.stat_group_code_num = sg.code
JOIN
sierra_view.itype_property_myuser it
ON
t.itype_code_num = it.code
JOIN
checkout_location cl
ON
t.id = cl.id
JOIN
sierra_view.location_myuser l
ON
cl.checkout_location = SUBSTRING(l.code,1,2) AND l.code ~ '^[a-z]{3}$' AND l.code != 'mls'
JOIN
sierra_view.bib_record_property b
ON
t.bib_record_id = b.bib_record_id
JOIN
sierra_view.material_property_myuser mat
ON
b.material_code = mat.code

WHERE
t.op_code = 'i'
AND t.transaction_gmt::DATE BETWEEN (CURRENT_DATE - INTERVAL '1 month') AND (CURRENT_DATE - INTERVAL '1 day')
AND CASE
	WHEN  {{location}} = '^ac' THEN (t.stat_group_code_num BETWEEN '100' AND '109' OR t.stat_group_code_num BETWEEN '870' AND '879')
	WHEN  {{location}} = '^act' THEN t.stat_group_code_num BETWEEN '100' AND '109'
	--location using the form ^act in order to reuse an existing filter
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
	WHEN  {{location}} = '^ww3' THEN t.stat_group_code_num = '831'
	WHEN  {{location}} = '^ww' THEN t.stat_group_code_num BETWEEN '810' AND '829' OR t.stat_group_code_num = '831'
	WHEN  {{location}} = '^reg' THEN t.stat_group_code_num BETWEEN '840' AND '849'
	WHEN  {{location}} = '^shr' THEN t.stat_group_code_num BETWEEN '850' AND '859'
	WHEN  {{location}} = '\w' THEN t.stat_group_code_num BETWEEN '100' AND '999'
END
GROUP BY 1

UNION

SELECT
'TOTAL',
COUNT(t.id) AS total_checkins,
COUNT(t.id) FILTER (WHERE t.due_date_gmt::DATE - t.transaction_gmt::DATE > 1) AS returned_greater_than_1_day_early,
COUNT(t.id) FILTER (WHERE t.due_date_gmt::DATE - t.transaction_gmt::DATE = 1) AS returned_1_day_early,
COUNT(t.id) FILTER (WHERE t.due_date_gmt::DATE = t.transaction_gmt::DATE) AS returned_on_time,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE = 1) AS returned_1_day_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE BETWEEN 2 AND 7) AS returned_2_to_7_days_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE BETWEEN 8 AND 14) AS returned_8_to_14_days_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE BETWEEN 15 AND 21) AS returned_15_to_21_days_late,
COUNT(t.id) FILTER (WHERE t.transaction_gmt::DATE - t.due_date_gmt::DATE > 21) AS returned_greater_than_21_days_late
FROM
sierra_view.circ_trans t
JOIN
sierra_view.statistic_group_myuser sg
ON
t.stat_group_code_num = sg.code
JOIN
sierra_view.itype_property_myuser it
ON
t.itype_code_num = it.code
JOIN
checkout_location cl
ON
t.id = cl.id
JOIN
sierra_view.location_myuser l
ON
cl.checkout_location = SUBSTRING(l.code,1,2) AND l.code ~ '^[a-z]{3}$' AND l.code != 'mls'
JOIN
sierra_view.bib_record_property b
ON
t.bib_record_id = b.bib_record_id
JOIN
sierra_view.material_property_myuser mat
ON
b.material_code = mat.code

WHERE
t.op_code = 'i'
AND t.transaction_gmt::DATE BETWEEN (CURRENT_DATE - INTERVAL '1 month') AND (CURRENT_DATE - INTERVAL '1 day')
AND CASE
	WHEN  {{location}} = '^act' THEN t.stat_group_code_num BETWEEN '100' AND '109'
	--location using the form ^act in order to reuse an existing filter
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
	WHEN  {{location}} = '^wat' THEN t.stat_group_code_num BETWEEN '710' AND '739'
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
	WHEN  {{location}} = '^ww3' THEN t.stat_group_code_num = '831'
	WHEN  {{location}} = '^ww' THEN t.stat_group_code_num BETWEEN '810' AND '829' OR t.stat_group_code_num = '831'
	WHEN  {{location}} = '^reg' THEN t.stat_group_code_num BETWEEN '840' AND '849'
	WHEN  {{location}} = '^shr' THEN t.stat_group_code_num BETWEEN '850' AND '859'
	WHEN  {{location}} = '\w' THEN t.stat_group_code_num BETWEEN '100' AND '999'
END
GROUP BY 1

)a

ORDER BY CASE
	WHEN grouping = 'TOTAL' THEN 2
	ELSE 1
END,
grouping
