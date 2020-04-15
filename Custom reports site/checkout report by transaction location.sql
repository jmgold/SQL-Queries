/*
Jeremy Goldstein
Minuteman Library Network
Provides various performance metrics for checkouts over the prior month
*/

SELECT
--Possible groupings
--it.name AS itype,
--C.icode1::VARCHAR AS scat,
--UPPER(SUBSTRING(C.item_location_code,1,3)) AS owning_location,
--p3.name AS MA_town,
--pt.name AS ptype,
--SG.name AS stat_group,
{{grouping}},
COUNT(C.id) FILTER(WHERE C.op_code = 'o') AS total_checkouts,
COUNT(C.id) FILTER(WHERE C.op_code = 'f') AS filled_holds,
ROUND(100.0 * CAST(COUNT(C.id) FILTER(WHERE C.op_code = 'f')AS NUMERIC (12,2)) / (COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_holds,
COUNT(C.id) FILTER(WHERE C.item_location_code ~ 'nat' AND C.op_code = 'o') AS local_items,
ROUND(100.0 * (CAST(COUNT(C.id) FILTER(WHERE C.item_location_code ~ 'nat'AND C.op_code = 'o')AS NUMERIC (12,2)) / COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_local,
COUNT(C.id) FILTER(WHERE C.item_location_code !~ 'nat'AND C.op_code = 'o') AS non_local_items,
ROUND(100.0 * (CAST(COUNT(C.id) FILTER(WHERE C.item_location_code !~ 'nat'AND C.op_code = 'o')AS NUMERIC (12,2)) / COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_non_local,
ROUND(100 * (CAST(COUNT(C.id) FILTER(WHERE C.op_code = 'o') AS NUMERIC (12,2)) / 
	(SELECT CAST(COUNT (C.id) as numeric (12,2)) FROM sierra_view.circ_trans C WHERE CASE 
	WHEN {{location}} = 'Acton' THEN (C.loanrule_code_num BETWEEN 2 AND 12 OR C.loanrule_code_num BETWEEN 501 AND 509)
	WHEN {{location}} = 'Arlington' THEN (C.loanrule_code_num BETWEEN 13 AND 23 OR C.loanrule_code_num BETWEEN 510 AND 518) 
	WHEN {{location}} = 'Ashland' THEN (C.loanrule_code_num BETWEEN 24 AND 34 OR C.loanrule_code_num BETWEEN 519 AND 527) 
	WHEN {{location}} = 'Bedford' THEN (C.loanrule_code_num BETWEEN 35 AND 45 OR C.loanrule_code_num BETWEEN 528 AND 536)
	WHEN {{location}} = 'Belmont' THEN (C.loanrule_code_num BETWEEN 46 AND 56 OR C.loanrule_code_num BETWEEN 537 AND 545)
	WHEN {{location}} = 'Brookline' THEN (C.loanrule_code_num BETWEEN 57 AND 67 OR C.loanrule_code_num BETWEEN 546 AND 554)
	WHEN {{location}} = 'Cambridge' THEN (C.loanrule_code_num BETWEEN 68 AND 78 OR C.loanrule_code_num BETWEEN 555 AND 563)
	WHEN {{location}} = 'Concord' THEN (C.loanrule_code_num BETWEEN 79 AND 89 OR C.loanrule_code_num BETWEEN 564 AND 572) 
	WHEN {{location}} = 'Dedham' THEN (C.loanrule_code_num BETWEEN 90 AND 100 OR C.loanrule_code_num BETWEEN 573 AND 581)
	WHEN {{location}} = 'Dean' THEN (C.loanrule_code_num BETWEEN 101 AND 111 OR C.loanrule_code_num BETWEEN 582 AND 590)
	WHEN {{location}} = 'Dover' THEN (C.loanrule_code_num BETWEEN 112 AND 122 OR C.loanrule_code_num BETWEEN 591 AND 599)
	WHEN {{location}} = 'Framingham' THEN (C.loanrule_code_num BETWEEN 123 AND 133 OR C.loanrule_code_num BETWEEN 600 AND 608)
	WHEN {{location}} = 'Franklin' THEN (C.loanrule_code_num BETWEEN 134 AND 144 OR C.loanrule_code_num BETWEEN 609 AND 617)
	WHEN {{location}} = 'Framingham State' THEN (C.loanrule_code_num BETWEEN 145 AND 155 OR C.loanrule_code_num BETWEEN 618 AND 626)
	WHEN {{location}} = 'Holliston' THEN (C.loanrule_code_num BETWEEN 156 AND 166 OR C.loanrule_code_num BETWEEN 627 AND 635)
	WHEN {{location}} = 'Lasell' THEN (C.loanrule_code_num BETWEEN 167 AND 177 OR C.loanrule_code_num BETWEEN 636 AND 644)
	WHEN {{location}} = 'Lexington' THEN (C.loanrule_code_num BETWEEN 178 AND 188 OR C.loanrule_code_num BETWEEN 645 AND 653) 
	WHEN {{location}} = 'Lincoln' THEN (C.loanrule_code_num BETWEEN 189 AND 199 OR C.loanrule_code_num BETWEEN 654 AND 662)
	WHEN {{location}} = 'Maynard' THEN (C.loanrule_code_num BETWEEN 200 AND 210 OR C.loanrule_code_num BETWEEN 663 AND 671)
	WHEN {{location}} = 'Medford' THEN (C.loanrule_code_num BETWEEN 222 AND 232 OR C.loanrule_code_num BETWEEN 681 AND 689) 
	WHEN {{location}} = 'Millis' THEN (C.loanrule_code_num BETWEEN 233 AND 243 OR C.loanrule_code_num BETWEEN 690 AND 698) 
	WHEN {{location}} = 'Medfield' THEN (C.loanrule_code_num BETWEEN 244 AND 254 OR C.loanrule_code_num BETWEEN 699 AND 707)
	WHEN {{location}} = 'Medway' THEN (C.loanrule_code_num BETWEEN 266 AND 276 OR C.loanrule_code_num BETWEEN 717 AND 725) 
	WHEN {{location}} = 'Natick' THEN (C.loanrule_code_num BETWEEN 277 AND 287 OR C.loanrule_code_num BETWEEN 726 AND 734)
	WHEN {{location}} = 'Needham' THEN( C.loanrule_code_num BETWEEN 299 AND 309 OR C.loanrule_code_num BETWEEN 744 AND 752) 
	WHEN {{location}} = 'Norwood' THEN (C.loanrule_code_num BETWEEN 310 AND 320 OR C.loanrule_code_num BETWEEN 753 AND 761) 
	WHEN {{location}} = 'Newton' THEN (C.loanrule_code_num BETWEEN 321 AND 331 OR C.loanrule_code_num BETWEEN 762 AND 770) 
	WHEN {{location}} = 'Olin' THEN (C.loanrule_code_num BETWEEN 289 AND 298 OR C.loanrule_code_num BETWEEN 734 AND 743)
	WHEN {{location}} = 'Somerville' THEN (C.loanrule_code_num BETWEEN 332 AND 342 OR C.loanrule_code_num BETWEEN 771 AND 779) 
	WHEN {{location}} = 'Stow' THEN (C.loanrule_code_num BETWEEN 343 AND 353 OR C.loanrule_code_num BETWEEN 780 AND 788) 
	WHEN {{location}} = 'Sudbury' THEN (C.loanrule_code_num BETWEEN 354 AND 364 OR C.loanrule_code_num BETWEEN 789 AND 797)
	WHEN {{location}} = 'Watertown' THEN (C.loanrule_code_num BETWEEN 365 AND 375 OR C.loanrule_code_num BETWEEN 798 AND 806) 
	WHEN {{location}} = 'Wellesley' THEN (C.loanrule_code_num BETWEEN 376 AND 386 OR C.loanrule_code_num BETWEEN 807 AND 815) 
	WHEN {{location}} = 'Winchester' THEN (C.loanrule_code_num BETWEEN 387 AND 397 OR C.loanrule_code_num BETWEEN 816 AND 824) 
	WHEN {{location}} = 'Waltham' THEN (C.loanrule_code_num BETWEEN 398 AND 408 OR C.loanrule_code_num BETWEEN 825 AND 833) 
	WHEN {{location}} = 'Woburn' THEN (C.loanrule_code_num BETWEEN 409 AND 419 OR C.loanrule_code_num BETWEEN 834 AND 842)
	WHEN {{location}} = 'Weston' THEN (C.loanrule_code_num BETWEEN 420 AND 430 OR C.loanrule_code_num BETWEEN 843 AND 851) 
	WHEN {{location}} = 'Westwood' THEN (C.loanrule_code_num BETWEEN 431 AND 441 OR C.loanrule_code_num BETWEEN 852 AND 860) 
	WHEN {{location}} = 'Wayland' THEN (C.loanrule_code_num BETWEEN 442 AND 452 OR C.loanrule_code_num BETWEEN 861 AND 869) 
	WHEN {{location}} = 'Pine Manor' THEN (C.loanrule_code_num BETWEEN 453 AND 463 OR C.loanrule_code_num BETWEEN 870 AND 878) 
	WHEN {{location}} = 'Regis' THEN (C.loanrule_code_num BETWEEN 464 AND 474 OR C.loanrule_code_num BETWEEN 879 AND 887) 
	WHEN {{location}} = 'Sherborn' THEN (C.loanrule_code_num BETWEEN 475 AND 485 OR C.loanrule_code_num BETWEEN 888 AND 896) 
	ELSE C.loanrule_code_num = 0
	END AND C.op_code = 'o' AND C.transaction_gmt::DATE >= NOW()::DATE - INTERVAL '1 month')), 6)||'%' AS relative_checkout_total,
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
	WHEN {{location}} = 'Acton' THEN (C.loanrule_code_num BETWEEN 2 AND 12 OR C.loanrule_code_num BETWEEN 501 AND 509)
	WHEN {{location}} = 'Arlington' THEN (C.loanrule_code_num BETWEEN 13 AND 23 OR C.loanrule_code_num BETWEEN 510 AND 518) 
	WHEN {{location}} = 'Ashland' THEN (C.loanrule_code_num BETWEEN 24 AND 34 OR C.loanrule_code_num BETWEEN 519 AND 527) 
	WHEN {{location}} = 'Bedford' THEN (C.loanrule_code_num BETWEEN 35 AND 45 OR C.loanrule_code_num BETWEEN 528 AND 536)
	WHEN {{location}} = 'Belmont' THEN (C.loanrule_code_num BETWEEN 46 AND 56 OR C.loanrule_code_num BETWEEN 537 AND 545)
	WHEN {{location}} = 'Brookline' THEN (C.loanrule_code_num BETWEEN 57 AND 67 OR C.loanrule_code_num BETWEEN 546 AND 554)
	WHEN {{location}} = 'Cambridge' THEN (C.loanrule_code_num BETWEEN 68 AND 78 OR C.loanrule_code_num BETWEEN 555 AND 563)
	WHEN {{location}} = 'Concord' THEN (C.loanrule_code_num BETWEEN 79 AND 89 OR C.loanrule_code_num BETWEEN 564 AND 572) 
	WHEN {{location}} = 'Dedham' THEN (C.loanrule_code_num BETWEEN 90 AND 100 OR C.loanrule_code_num BETWEEN 573 AND 581)
	WHEN {{location}} = 'Dean' THEN (C.loanrule_code_num BETWEEN 101 AND 111 OR C.loanrule_code_num BETWEEN 582 AND 590)
	WHEN {{location}} = 'Dover' THEN (C.loanrule_code_num BETWEEN 112 AND 122 OR C.loanrule_code_num BETWEEN 591 AND 599)
	WHEN {{location}} = 'Framingham' THEN (C.loanrule_code_num BETWEEN 123 AND 133 OR C.loanrule_code_num BETWEEN 600 AND 608)
	WHEN {{location}} = 'Franklin' THEN (C.loanrule_code_num BETWEEN 134 AND 144 OR C.loanrule_code_num BETWEEN 609 AND 617)
	WHEN {{location}} = 'Framingham State' THEN (C.loanrule_code_num BETWEEN 145 AND 155 OR C.loanrule_code_num BETWEEN 618 AND 626)
	WHEN {{location}} = 'Holliston' THEN (C.loanrule_code_num BETWEEN 156 AND 166 OR C.loanrule_code_num BETWEEN 627 AND 635)
	WHEN {{location}} = 'Lasell' THEN (C.loanrule_code_num BETWEEN 167 AND 177 OR C.loanrule_code_num BETWEEN 636 AND 644)
	WHEN {{location}} = 'Lexington' THEN (C.loanrule_code_num BETWEEN 178 AND 188 OR C.loanrule_code_num BETWEEN 645 AND 653) 
	WHEN {{location}} = 'Lincoln' THEN (C.loanrule_code_num BETWEEN 189 AND 199 OR C.loanrule_code_num BETWEEN 654 AND 662)
	WHEN {{location}} = 'Maynard' THEN (C.loanrule_code_num BETWEEN 200 AND 210 OR C.loanrule_code_num BETWEEN 663 AND 671)
	WHEN {{location}} = 'Medford' THEN (C.loanrule_code_num BETWEEN 222 AND 232 OR C.loanrule_code_num BETWEEN 681 AND 689) 
	WHEN {{location}} = 'Millis' THEN (C.loanrule_code_num BETWEEN 233 AND 243 OR C.loanrule_code_num BETWEEN 690 AND 698) 
	WHEN {{location}} = 'Medfield' THEN (C.loanrule_code_num BETWEEN 244 AND 254 OR C.loanrule_code_num BETWEEN 699 AND 707)
	WHEN {{location}} = 'Medway' THEN (C.loanrule_code_num BETWEEN 266 AND 276 OR C.loanrule_code_num BETWEEN 717 AND 725) 
	WHEN {{location}} = 'Natick' THEN (C.loanrule_code_num BETWEEN 277 AND 287 OR C.loanrule_code_num BETWEEN 726 AND 734)
	WHEN {{location}} = 'Needham' THEN( C.loanrule_code_num BETWEEN 299 AND 309 OR C.loanrule_code_num BETWEEN 744 AND 752) 
	WHEN {{location}} = 'Norwood' THEN (C.loanrule_code_num BETWEEN 310 AND 320 OR C.loanrule_code_num BETWEEN 753 AND 761) 
	WHEN {{location}} = 'Newton' THEN (C.loanrule_code_num BETWEEN 321 AND 331 OR C.loanrule_code_num BETWEEN 762 AND 770) 
	WHEN {{location}} = 'Olin' THEN (C.loanrule_code_num BETWEEN 289 AND 298 OR C.loanrule_code_num BETWEEN 734 AND 743)
	WHEN {{location}} = 'Somerville' THEN (C.loanrule_code_num BETWEEN 332 AND 342 OR C.loanrule_code_num BETWEEN 771 AND 779) 
	WHEN {{location}} = 'Stow' THEN (C.loanrule_code_num BETWEEN 343 AND 353 OR C.loanrule_code_num BETWEEN 780 AND 788) 
	WHEN {{location}} = 'Sudbury' THEN (C.loanrule_code_num BETWEEN 354 AND 364 OR C.loanrule_code_num BETWEEN 789 AND 797)
	WHEN {{location}} = 'Watertown' THEN (C.loanrule_code_num BETWEEN 365 AND 375 OR C.loanrule_code_num BETWEEN 798 AND 806) 
	WHEN {{location}} = 'Wellesley' THEN (C.loanrule_code_num BETWEEN 376 AND 386 OR C.loanrule_code_num BETWEEN 807 AND 815) 
	WHEN {{location}} = 'Winchester' THEN (C.loanrule_code_num BETWEEN 387 AND 397 OR C.loanrule_code_num BETWEEN 816 AND 824) 
	WHEN {{location}} = 'Waltham' THEN (C.loanrule_code_num BETWEEN 398 AND 408 OR C.loanrule_code_num BETWEEN 825 AND 833) 
	WHEN {{location}} = 'Woburn' THEN (C.loanrule_code_num BETWEEN 409 AND 419 OR C.loanrule_code_num BETWEEN 834 AND 842)
	WHEN {{location}} = 'Weston' THEN (C.loanrule_code_num BETWEEN 420 AND 430 OR C.loanrule_code_num BETWEEN 843 AND 851) 
	WHEN {{location}} = 'Westwood' THEN (C.loanrule_code_num BETWEEN 431 AND 441 OR C.loanrule_code_num BETWEEN 852 AND 860) 
	WHEN {{location}} = 'Wayland' THEN (C.loanrule_code_num BETWEEN 442 AND 452 OR C.loanrule_code_num BETWEEN 861 AND 869) 
	WHEN {{location}} = 'Pine Manor' THEN (C.loanrule_code_num BETWEEN 453 AND 463 OR C.loanrule_code_num BETWEEN 870 AND 878) 
	WHEN {{location}} = 'Regis' THEN (C.loanrule_code_num BETWEEN 464 AND 474 OR C.loanrule_code_num BETWEEN 879 AND 887) 
	WHEN {{location}} = 'Sherborn' THEN (C.loanrule_code_num BETWEEN 475 AND 485 OR C.loanrule_code_num BETWEEN 888 AND 896) 
	ELSE C.loanrule_code_num = 0
	END
AND C.op_code IN ('o','f')
AND C.transaction_gmt::DATE >= NOW()::DATE - INTERVAL '1 month'

GROUP BY 1

UNION

SELECT
'total' AS total,
COUNT(C.id) FILTER(WHERE C.op_code = 'o') AS total_checkouts,
COUNT(C.id) FILTER(WHERE C.op_code = 'f') AS filled_holds,
ROUND(100.0 * CAST(COUNT(C.id) FILTER(WHERE C.op_code = 'f')AS NUMERIC (12,2)) / (COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_holds,
COUNT(C.id) FILTER(WHERE C.item_location_code ~ 'nat' AND C.op_code = 'o') AS local_items,
ROUND(100.0 * (CAST(COUNT(C.id) FILTER(WHERE C.item_location_code ~ 'nat'AND C.op_code = 'o')AS NUMERIC (12,2)) / COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_local,
COUNT(C.id) FILTER(WHERE C.item_location_code !~ 'nat'AND C.op_code = 'o') AS non_local_items,
ROUND(100.0 * (CAST(COUNT(C.id) FILTER(WHERE C.item_location_code !~ 'nat'AND C.op_code = 'o')AS NUMERIC (12,2)) / COUNT(C.id) FILTER(WHERE C.op_code = 'o')),2)||'%' AS pct_non_local,
ROUND(100 * (CAST(COUNT(C.id) FILTER(WHERE C.op_code = 'o') AS NUMERIC (12,2)) / 
	(SELECT CAST(COUNT (C.id) as numeric (12,2)) FROM sierra_view.circ_trans C WHERE CASE 
	WHEN {{location}} = 'Acton' THEN (C.loanrule_code_num BETWEEN 2 AND 12 OR C.loanrule_code_num BETWEEN 501 AND 509)
	WHEN {{location}} = 'Arlington' THEN (C.loanrule_code_num BETWEEN 13 AND 23 OR C.loanrule_code_num BETWEEN 510 AND 518) 
	WHEN {{location}} = 'Ashland' THEN (C.loanrule_code_num BETWEEN 24 AND 34 OR C.loanrule_code_num BETWEEN 519 AND 527) 
	WHEN {{location}} = 'Bedford' THEN (C.loanrule_code_num BETWEEN 35 AND 45 OR C.loanrule_code_num BETWEEN 528 AND 536)
	WHEN {{location}} = 'Belmont' THEN (C.loanrule_code_num BETWEEN 46 AND 56 OR C.loanrule_code_num BETWEEN 537 AND 545)
	WHEN {{location}} = 'Brookline' THEN (C.loanrule_code_num BETWEEN 57 AND 67 OR C.loanrule_code_num BETWEEN 546 AND 554)
	WHEN {{location}} = 'Cambridge' THEN (C.loanrule_code_num BETWEEN 68 AND 78 OR C.loanrule_code_num BETWEEN 555 AND 563)
	WHEN {{location}} = 'Concord' THEN (C.loanrule_code_num BETWEEN 79 AND 89 OR C.loanrule_code_num BETWEEN 564 AND 572) 
	WHEN {{location}} = 'Dedham' THEN (C.loanrule_code_num BETWEEN 90 AND 100 OR C.loanrule_code_num BETWEEN 573 AND 581)
	WHEN {{location}} = 'Dean' THEN (C.loanrule_code_num BETWEEN 101 AND 111 OR C.loanrule_code_num BETWEEN 582 AND 590)
	WHEN {{location}} = 'Dover' THEN (C.loanrule_code_num BETWEEN 112 AND 122 OR C.loanrule_code_num BETWEEN 591 AND 599)
	WHEN {{location}} = 'Framingham' THEN (C.loanrule_code_num BETWEEN 123 AND 133 OR C.loanrule_code_num BETWEEN 600 AND 608)
	WHEN {{location}} = 'Franklin' THEN (C.loanrule_code_num BETWEEN 134 AND 144 OR C.loanrule_code_num BETWEEN 609 AND 617)
	WHEN {{location}} = 'Framingham State' THEN (C.loanrule_code_num BETWEEN 145 AND 155 OR C.loanrule_code_num BETWEEN 618 AND 626)
	WHEN {{location}} = 'Holliston' THEN (C.loanrule_code_num BETWEEN 156 AND 166 OR C.loanrule_code_num BETWEEN 627 AND 635)
	WHEN {{location}} = 'Lasell' THEN (C.loanrule_code_num BETWEEN 167 AND 177 OR C.loanrule_code_num BETWEEN 636 AND 644)
	WHEN {{location}} = 'Lexington' THEN (C.loanrule_code_num BETWEEN 178 AND 188 OR C.loanrule_code_num BETWEEN 645 AND 653) 
	WHEN {{location}} = 'Lincoln' THEN (C.loanrule_code_num BETWEEN 189 AND 199 OR C.loanrule_code_num BETWEEN 654 AND 662)
	WHEN {{location}} = 'Maynard' THEN (C.loanrule_code_num BETWEEN 200 AND 210 OR C.loanrule_code_num BETWEEN 663 AND 671)
	WHEN {{location}} = 'Medford' THEN (C.loanrule_code_num BETWEEN 222 AND 232 OR C.loanrule_code_num BETWEEN 681 AND 689) 
	WHEN {{location}} = 'Millis' THEN (C.loanrule_code_num BETWEEN 233 AND 243 OR C.loanrule_code_num BETWEEN 690 AND 698) 
	WHEN {{location}} = 'Medfield' THEN (C.loanrule_code_num BETWEEN 244 AND 254 OR C.loanrule_code_num BETWEEN 699 AND 707)
	WHEN {{location}} = 'Medway' THEN (C.loanrule_code_num BETWEEN 266 AND 276 OR C.loanrule_code_num BETWEEN 717 AND 725) 
	WHEN {{location}} = 'Natick' THEN (C.loanrule_code_num BETWEEN 277 AND 287 OR C.loanrule_code_num BETWEEN 726 AND 734)
	WHEN {{location}} = 'Needham' THEN( C.loanrule_code_num BETWEEN 299 AND 309 OR C.loanrule_code_num BETWEEN 744 AND 752) 
	WHEN {{location}} = 'Norwood' THEN (C.loanrule_code_num BETWEEN 310 AND 320 OR C.loanrule_code_num BETWEEN 753 AND 761) 
	WHEN {{location}} = 'Newton' THEN (C.loanrule_code_num BETWEEN 321 AND 331 OR C.loanrule_code_num BETWEEN 762 AND 770) 
	WHEN {{location}} = 'Olin' THEN (C.loanrule_code_num BETWEEN 289 AND 298 OR C.loanrule_code_num BETWEEN 734 AND 743)
	WHEN {{location}} = 'Somerville' THEN (C.loanrule_code_num BETWEEN 332 AND 342 OR C.loanrule_code_num BETWEEN 771 AND 779) 
	WHEN {{location}} = 'Stow' THEN (C.loanrule_code_num BETWEEN 343 AND 353 OR C.loanrule_code_num BETWEEN 780 AND 788) 
	WHEN {{location}} = 'Sudbury' THEN (C.loanrule_code_num BETWEEN 354 AND 364 OR C.loanrule_code_num BETWEEN 789 AND 797)
	WHEN {{location}} = 'Watertown' THEN (C.loanrule_code_num BETWEEN 365 AND 375 OR C.loanrule_code_num BETWEEN 798 AND 806) 
	WHEN {{location}} = 'Wellesley' THEN (C.loanrule_code_num BETWEEN 376 AND 386 OR C.loanrule_code_num BETWEEN 807 AND 815) 
	WHEN {{location}} = 'Winchester' THEN (C.loanrule_code_num BETWEEN 387 AND 397 OR C.loanrule_code_num BETWEEN 816 AND 824) 
	WHEN {{location}} = 'Waltham' THEN (C.loanrule_code_num BETWEEN 398 AND 408 OR C.loanrule_code_num BETWEEN 825 AND 833) 
	WHEN {{location}} = 'Woburn' THEN (C.loanrule_code_num BETWEEN 409 AND 419 OR C.loanrule_code_num BETWEEN 834 AND 842)
	WHEN {{location}} = 'Weston' THEN (C.loanrule_code_num BETWEEN 420 AND 430 OR C.loanrule_code_num BETWEEN 843 AND 851) 
	WHEN {{location}} = 'Westwood' THEN (C.loanrule_code_num BETWEEN 431 AND 441 OR C.loanrule_code_num BETWEEN 852 AND 860) 
	WHEN {{location}} = 'Wayland' THEN (C.loanrule_code_num BETWEEN 442 AND 452 OR C.loanrule_code_num BETWEEN 861 AND 869) 
	WHEN {{location}} = 'Pine Manor' THEN (C.loanrule_code_num BETWEEN 453 AND 463 OR C.loanrule_code_num BETWEEN 870 AND 878) 
	WHEN {{location}} = 'Regis' THEN (C.loanrule_code_num BETWEEN 464 AND 474 OR C.loanrule_code_num BETWEEN 879 AND 887) 
	WHEN {{location}} = 'Sherborn' THEN (C.loanrule_code_num BETWEEN 475 AND 485 OR C.loanrule_code_num BETWEEN 888 AND 896) 
	ELSE C.loanrule_code_num = 0
	END AND C.op_code = 'o' AND C.transaction_gmt::DATE >= NOW()::DATE - INTERVAL '1 month')), 6)||'%' AS relative_checkout_total,
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
	WHEN {{location}} = 'Acton' THEN (C.loanrule_code_num BETWEEN 2 AND 12 OR C.loanrule_code_num BETWEEN 501 AND 509)
	WHEN {{location}} = 'Arlington' THEN (C.loanrule_code_num BETWEEN 13 AND 23 OR C.loanrule_code_num BETWEEN 510 AND 518) 
	WHEN {{location}} = 'Ashland' THEN (C.loanrule_code_num BETWEEN 24 AND 34 OR C.loanrule_code_num BETWEEN 519 AND 527) 
	WHEN {{location}} = 'Bedford' THEN (C.loanrule_code_num BETWEEN 35 AND 45 OR C.loanrule_code_num BETWEEN 528 AND 536)
	WHEN {{location}} = 'Belmont' THEN (C.loanrule_code_num BETWEEN 46 AND 56 OR C.loanrule_code_num BETWEEN 537 AND 545)
	WHEN {{location}} = 'Brookline' THEN (C.loanrule_code_num BETWEEN 57 AND 67 OR C.loanrule_code_num BETWEEN 546 AND 554)
	WHEN {{location}} = 'Cambridge' THEN (C.loanrule_code_num BETWEEN 68 AND 78 OR C.loanrule_code_num BETWEEN 555 AND 563)
	WHEN {{location}} = 'Concord' THEN (C.loanrule_code_num BETWEEN 79 AND 89 OR C.loanrule_code_num BETWEEN 564 AND 572) 
	WHEN {{location}} = 'Dedham' THEN (C.loanrule_code_num BETWEEN 90 AND 100 OR C.loanrule_code_num BETWEEN 573 AND 581)
	WHEN {{location}} = 'Dean' THEN (C.loanrule_code_num BETWEEN 101 AND 111 OR C.loanrule_code_num BETWEEN 582 AND 590)
	WHEN {{location}} = 'Dover' THEN (C.loanrule_code_num BETWEEN 112 AND 122 OR C.loanrule_code_num BETWEEN 591 AND 599)
	WHEN {{location}} = 'Framingham' THEN (C.loanrule_code_num BETWEEN 123 AND 133 OR C.loanrule_code_num BETWEEN 600 AND 608)
	WHEN {{location}} = 'Franklin' THEN (C.loanrule_code_num BETWEEN 134 AND 144 OR C.loanrule_code_num BETWEEN 609 AND 617)
	WHEN {{location}} = 'Framingham State' THEN (C.loanrule_code_num BETWEEN 145 AND 155 OR C.loanrule_code_num BETWEEN 618 AND 626)
	WHEN {{location}} = 'Holliston' THEN (C.loanrule_code_num BETWEEN 156 AND 166 OR C.loanrule_code_num BETWEEN 627 AND 635)
	WHEN {{location}} = 'Lasell' THEN (C.loanrule_code_num BETWEEN 167 AND 177 OR C.loanrule_code_num BETWEEN 636 AND 644)
	WHEN {{location}} = 'Lexington' THEN (C.loanrule_code_num BETWEEN 178 AND 188 OR C.loanrule_code_num BETWEEN 645 AND 653) 
	WHEN {{location}} = 'Lincoln' THEN (C.loanrule_code_num BETWEEN 189 AND 199 OR C.loanrule_code_num BETWEEN 654 AND 662)
	WHEN {{location}} = 'Maynard' THEN (C.loanrule_code_num BETWEEN 200 AND 210 OR C.loanrule_code_num BETWEEN 663 AND 671)
	WHEN {{location}} = 'Medford' THEN (C.loanrule_code_num BETWEEN 222 AND 232 OR C.loanrule_code_num BETWEEN 681 AND 689) 
	WHEN {{location}} = 'Millis' THEN (C.loanrule_code_num BETWEEN 233 AND 243 OR C.loanrule_code_num BETWEEN 690 AND 698) 
	WHEN {{location}} = 'Medfield' THEN (C.loanrule_code_num BETWEEN 244 AND 254 OR C.loanrule_code_num BETWEEN 699 AND 707)
	WHEN {{location}} = 'Medway' THEN (C.loanrule_code_num BETWEEN 266 AND 276 OR C.loanrule_code_num BETWEEN 717 AND 725) 
	WHEN {{location}} = 'Natick' THEN (C.loanrule_code_num BETWEEN 277 AND 287 OR C.loanrule_code_num BETWEEN 726 AND 734)
	WHEN {{location}} = 'Needham' THEN( C.loanrule_code_num BETWEEN 299 AND 309 OR C.loanrule_code_num BETWEEN 744 AND 752) 
	WHEN {{location}} = 'Norwood' THEN (C.loanrule_code_num BETWEEN 310 AND 320 OR C.loanrule_code_num BETWEEN 753 AND 761) 
	WHEN {{location}} = 'Newton' THEN (C.loanrule_code_num BETWEEN 321 AND 331 OR C.loanrule_code_num BETWEEN 762 AND 770) 
	WHEN {{location}} = 'Olin' THEN (C.loanrule_code_num BETWEEN 289 AND 298 OR C.loanrule_code_num BETWEEN 734 AND 743)
	WHEN {{location}} = 'Somerville' THEN (C.loanrule_code_num BETWEEN 332 AND 342 OR C.loanrule_code_num BETWEEN 771 AND 779) 
	WHEN {{location}} = 'Stow' THEN (C.loanrule_code_num BETWEEN 343 AND 353 OR C.loanrule_code_num BETWEEN 780 AND 788) 
	WHEN {{location}} = 'Sudbury' THEN (C.loanrule_code_num BETWEEN 354 AND 364 OR C.loanrule_code_num BETWEEN 789 AND 797)
	WHEN {{location}} = 'Watertown' THEN (C.loanrule_code_num BETWEEN 365 AND 375 OR C.loanrule_code_num BETWEEN 798 AND 806) 
	WHEN {{location}} = 'Wellesley' THEN (C.loanrule_code_num BETWEEN 376 AND 386 OR C.loanrule_code_num BETWEEN 807 AND 815) 
	WHEN {{location}} = 'Winchester' THEN (C.loanrule_code_num BETWEEN 387 AND 397 OR C.loanrule_code_num BETWEEN 816 AND 824) 
	WHEN {{location}} = 'Waltham' THEN (C.loanrule_code_num BETWEEN 398 AND 408 OR C.loanrule_code_num BETWEEN 825 AND 833) 
	WHEN {{location}} = 'Woburn' THEN (C.loanrule_code_num BETWEEN 409 AND 419 OR C.loanrule_code_num BETWEEN 834 AND 842)
	WHEN {{location}} = 'Weston' THEN (C.loanrule_code_num BETWEEN 420 AND 430 OR C.loanrule_code_num BETWEEN 843 AND 851) 
	WHEN {{location}} = 'Westwood' THEN (C.loanrule_code_num BETWEEN 431 AND 441 OR C.loanrule_code_num BETWEEN 852 AND 860) 
	WHEN {{location}} = 'Wayland' THEN (C.loanrule_code_num BETWEEN 442 AND 452 OR C.loanrule_code_num BETWEEN 861 AND 869) 
	WHEN {{location}} = 'Pine Manor' THEN (C.loanrule_code_num BETWEEN 453 AND 463 OR C.loanrule_code_num BETWEEN 870 AND 878) 
	WHEN {{location}} = 'Regis' THEN (C.loanrule_code_num BETWEEN 464 AND 474 OR C.loanrule_code_num BETWEEN 879 AND 887) 
	WHEN {{location}} = 'Sherborn' THEN (C.loanrule_code_num BETWEEN 475 AND 485 OR C.loanrule_code_num BETWEEN 888 AND 896) 
	ELSE C.loanrule_code_num = 0
END
AND C.op_code IN ('o','f')
AND C.transaction_gmt::DATE >= NOW()::DATE - INTERVAL '1 month'

ORDER BY 1