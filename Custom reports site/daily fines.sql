/*
Jeremy Goldstein
Minuteman Library Network

Provides numbers for fines assessed and paid daily for the past month
*/

WITH paid_per_day AS (
SELECT
d.all_dates AS paid_date,
COUNT(fp.id) FILTER (WHERE fp.payment_status_code NOT IN ('3','0')) AS fines_paid_count,
COUNT(fp.id) FILTER (WHERE fp.payment_status_code = '3') AS fines_waived_count,
COUNT(fp.id) FILTER (WHERE fp.payment_status_code = '0') AS fines_removed_count,
COALESCE(SUM(
CASE
	WHEN fp.payment_status_code = '2' THEN fp.paid_now_amt
	ELSE fp.item_charge_amt + fp.processing_fee_amt + fp.processing_fee_amt
END
) FILTER (WHERE fp.payment_status_code NOT IN ('3','0')),'0')::MONEY AS fines_paid_total,
COALESCE(SUM(fp.item_charge_amt + fp.processing_fee_amt + fp.processing_fee_amt) FILTER (WHERE fp.payment_status_code = '3'),'0')::MONEY AS fines_waived_total,
COALESCE(SUM(fp.item_charge_amt + fp.processing_fee_amt + fp.processing_fee_amt) FILTER (WHERE fp.payment_status_code = '0'),'0')::MONEY AS fines_removed_total

FROM
sierra_view.fines_paid fp
FULL OUTER JOIN
(SELECT
DISTINCT (current_date - offs)::DATE AS all_dates 
FROM generate_series(0,35,1) AS offs) d
ON
fp.paid_date_gmt::DATE = d.all_dates


WHERE
fp.paid_date_gmt >= NOW()::DATE - INTERVAL '1 month'
AND fp.charge_type_code IN ({{charge_codes}})
AND CASE 
	WHEN {{location}} = 'Acton' THEN (fp.loan_rule_code_num BETWEEN 2 AND 12 OR fp.loan_rule_code_num BETWEEN 501 AND 509)
	WHEN {{location}} = 'Arlington' THEN (fp.loan_rule_code_num BETWEEN 13 AND 23 OR fp.loan_rule_code_num BETWEEN 510 AND 518) 
	WHEN {{location}} = 'Ashland' THEN (fp.loan_rule_code_num BETWEEN 24 AND 34 OR fp.loan_rule_code_num BETWEEN 519 AND 527) 
	WHEN {{location}} = 'Bedford' THEN (fp.loan_rule_code_num BETWEEN 35 AND 45 OR fp.loan_rule_code_num BETWEEN 528 AND 536)
	WHEN {{location}} = 'Belmont' THEN (fp.loan_rule_code_num BETWEEN 46 AND 56 OR fp.loan_rule_code_num BETWEEN 537 AND 545)
	WHEN {{location}} = 'Brookline' THEN (fp.loan_rule_code_num BETWEEN 57 AND 67 OR fp.loan_rule_code_num BETWEEN 546 AND 554)
	WHEN {{location}} = 'Cambridge' THEN (fp.loan_rule_code_num BETWEEN 68 AND 78 OR fp.loan_rule_code_num BETWEEN 555 AND 563)
	WHEN {{location}} = 'Concord' THEN (fp.loan_rule_code_num BETWEEN 79 AND 89 OR fp.loan_rule_code_num BETWEEN 564 AND 572) 
	WHEN {{location}} = 'Dedham' THEN (fp.loan_rule_code_num BETWEEN 90 AND 100 OR fp.loan_rule_code_num BETWEEN 573 AND 581)
	WHEN {{location}} = 'Dean' THEN (fp.loan_rule_code_num BETWEEN 101 AND 111 OR fp.loan_rule_code_num BETWEEN 582 AND 590)
	WHEN {{location}} = 'Dover' THEN (fp.loan_rule_code_num BETWEEN 112 AND 122 OR fp.loan_rule_code_num BETWEEN 591 AND 599)
	WHEN {{location}} = 'Framingham' THEN (fp.loan_rule_code_num BETWEEN 123 AND 133 OR fp.loan_rule_code_num BETWEEN 600 AND 608)
	WHEN {{location}} = 'Franklin' THEN (fp.loan_rule_code_num BETWEEN 134 AND 144 OR fp.loan_rule_code_num BETWEEN 609 AND 617)
	WHEN {{location}} = 'Framingham State' THEN (fp.loan_rule_code_num BETWEEN 145 AND 155 OR fp.loan_rule_code_num BETWEEN 618 AND 626)
	WHEN {{location}} = 'Holliston' THEN (fp.loan_rule_code_num BETWEEN 156 AND 166 OR fp.loan_rule_code_num BETWEEN 627 AND 635)
	WHEN {{location}} = 'Lasell' THEN (fp.loan_rule_code_num BETWEEN 167 AND 177 OR fp.loan_rule_code_num BETWEEN 636 AND 644)
	WHEN {{location}} = 'Lexington' THEN (fp.loan_rule_code_num BETWEEN 178 AND 188 OR fp.loan_rule_code_num BETWEEN 645 AND 653) 
	WHEN {{location}} = 'Lincoln' THEN (fp.loan_rule_code_num BETWEEN 189 AND 199 OR fp.loan_rule_code_num BETWEEN 654 AND 662)
	WHEN {{location}} = 'Maynard' THEN (fp.loan_rule_code_num BETWEEN 200 AND 210 OR fp.loan_rule_code_num BETWEEN 663 AND 671)
	WHEN {{location}} = 'Medford' THEN (fp.loan_rule_code_num BETWEEN 222 AND 232 OR fp.loan_rule_code_num BETWEEN 681 AND 689) 
	WHEN {{location}} = 'Millis' THEN (fp.loan_rule_code_num BETWEEN 233 AND 243 OR fp.loan_rule_code_num BETWEEN 690 AND 698) 
	WHEN {{location}} = 'Medfield' THEN (fp.loan_rule_code_num BETWEEN 244 AND 254 OR fp.loan_rule_code_num BETWEEN 699 AND 707)
	WHEN {{location}} = 'Medway' THEN (fp.loan_rule_code_num BETWEEN 266 AND 276 OR fp.loan_rule_code_num BETWEEN 717 AND 725) 
	WHEN {{location}} = 'Natick' THEN (fp.loan_rule_code_num BETWEEN 277 AND 287 OR fp.loan_rule_code_num BETWEEN 726 AND 734)
	WHEN {{location}} = 'Needham' THEN( fp.loan_rule_code_num BETWEEN 299 AND 309 OR fp.loan_rule_code_num BETWEEN 744 AND 752) 
	WHEN {{location}} = 'Norwood' THEN (fp.loan_rule_code_num BETWEEN 310 AND 320 OR fp.loan_rule_code_num BETWEEN 753 AND 761) 
	WHEN {{location}} = 'Newton' THEN (fp.loan_rule_code_num BETWEEN 321 AND 331 OR fp.loan_rule_code_num BETWEEN 762 AND 770) 
	WHEN {{location}} = 'Olin' THEN (fp.loan_rule_code_num BETWEEN 289 AND 298 OR fp.loan_rule_code_num BETWEEN 734 AND 743)
	WHEN {{location}} = 'Somerville' THEN (fp.loan_rule_code_num BETWEEN 332 AND 342 OR fp.loan_rule_code_num BETWEEN 771 AND 779) 
	WHEN {{location}} = 'Stow' THEN (fp.loan_rule_code_num BETWEEN 343 AND 353 OR fp.loan_rule_code_num BETWEEN 780 AND 788) 
	WHEN {{location}} = 'Sudbury' THEN (fp.loan_rule_code_num BETWEEN 354 AND 364 OR fp.loan_rule_code_num BETWEEN 789 AND 797)
	WHEN {{location}} = 'Watertown' THEN (fp.loan_rule_code_num BETWEEN 365 AND 375 OR fp.loan_rule_code_num BETWEEN 798 AND 806) 
	WHEN {{location}} = 'Wellesley' THEN (fp.loan_rule_code_num BETWEEN 376 AND 386 OR fp.loan_rule_code_num BETWEEN 807 AND 815) 
	WHEN {{location}} = 'Winchester' THEN (fp.loan_rule_code_num BETWEEN 387 AND 397 OR fp.loan_rule_code_num BETWEEN 816 AND 824) 
	WHEN {{location}} = 'Waltham' THEN (fp.loan_rule_code_num BETWEEN 398 AND 408 OR fp.loan_rule_code_num BETWEEN 825 AND 833) 
	WHEN {{location}} = 'Woburn' THEN (fp.loan_rule_code_num BETWEEN 409 AND 419 OR fp.loan_rule_code_num BETWEEN 834 AND 842)
	WHEN {{location}} = 'Weston' THEN (fp.loan_rule_code_num BETWEEN 420 AND 430 OR fp.loan_rule_code_num BETWEEN 843 AND 851) 
	WHEN {{location}} = 'Westwood' THEN (fp.loan_rule_code_num BETWEEN 431 AND 441 OR fp.loan_rule_code_num BETWEEN 852 AND 860) 
	WHEN {{location}} = 'Wayland' THEN (fp.loan_rule_code_num BETWEEN 442 AND 452 OR fp.loan_rule_code_num BETWEEN 861 AND 869) 
	WHEN {{location}} = 'Pine Manor' THEN (fp.loan_rule_code_num BETWEEN 453 AND 463 OR fp.loan_rule_code_num BETWEEN 870 AND 878) 
	WHEN {{location}} = 'Regis' THEN (fp.loan_rule_code_num BETWEEN 464 AND 474 OR fp.loan_rule_code_num BETWEEN 879 AND 887) 
	WHEN {{location}} = 'Sherborn' THEN (fp.loan_rule_code_num BETWEEN 475 AND 485 OR fp.loan_rule_code_num BETWEEN 888 AND 896) 
	ELSE fp.loan_rule_code_num = 0
END

GROUP BY 1
)

SELECT
d.all_dates AS DATE,
COUNT(DISTINCT f.id) FILTER (WHERE f.charge_code IN ({{charge_codes}})) AS fines_assessed_count,
COALESCE(SUM(f.item_charge_amt + f.processing_fee_amt + f.billing_fee_amt) FILTER (WHERE f.charge_code IN ({{charge_codes}})),'0')::MONEY AS fines_assessed_total,
p.fines_paid_count,
p.fines_paid_total,
p.fines_waived_count,
p.fines_waived_total,
p.fines_removed_count,
p.fines_removed_total


FROM
(SELECT
DISTINCT (current_date - offs)::DATE AS all_dates 
FROM generate_series(0,35,1) AS offs) d
LEFT JOIN
paid_per_day p
ON
d.all_dates = p.paid_date
LEFT JOIN
sierra_view.fine f
ON
d.all_dates = f.assessed_gmt::DATE


WHERE
d.all_dates >= NOW()::DATE - INTERVAL '1 month'
AND CASE 
	WHEN {{location}} = 'Acton' THEN (f.loanrule_code_num BETWEEN 2 AND 12 OR f.loanrule_code_num BETWEEN 501 AND 509)
	WHEN {{location}} = 'Arlington' THEN (f.loanrule_code_num BETWEEN 13 AND 23 OR f.loanrule_code_num BETWEEN 510 AND 518) 
	WHEN {{location}} = 'Ashland' THEN (f.loanrule_code_num BETWEEN 24 AND 34 OR f.loanrule_code_num BETWEEN 519 AND 527) 
	WHEN {{location}} = 'Bedford' THEN (f.loanrule_code_num BETWEEN 35 AND 45 OR f.loanrule_code_num BETWEEN 528 AND 536)
	WHEN {{location}} = 'Belmont' THEN (f.loanrule_code_num BETWEEN 46 AND 56 OR f.loanrule_code_num BETWEEN 537 AND 545)
	WHEN {{location}} = 'Brookline' THEN (f.loanrule_code_num BETWEEN 57 AND 67 OR f.loanrule_code_num BETWEEN 546 AND 554)
	WHEN {{location}} = 'Cambridge' THEN (f.loanrule_code_num BETWEEN 68 AND 78 OR f.loanrule_code_num BETWEEN 555 AND 563)
	WHEN {{location}} = 'Concord' THEN (f.loanrule_code_num BETWEEN 79 AND 89 OR f.loanrule_code_num BETWEEN 564 AND 572) 
	WHEN {{location}} = 'Dedham' THEN (f.loanrule_code_num BETWEEN 90 AND 100 OR f.loanrule_code_num BETWEEN 573 AND 581)
	WHEN {{location}} = 'Dean' THEN (f.loanrule_code_num BETWEEN 101 AND 111 OR f.loanrule_code_num BETWEEN 582 AND 590)
	WHEN {{location}} = 'Dover' THEN (f.loanrule_code_num BETWEEN 112 AND 122 OR f.loanrule_code_num BETWEEN 591 AND 599)
	WHEN {{location}} = 'Framingham' THEN (f.loanrule_code_num BETWEEN 123 AND 133 OR f.loanrule_code_num BETWEEN 600 AND 608)
	WHEN {{location}} = 'Franklin' THEN (f.loanrule_code_num BETWEEN 134 AND 144 OR f.loanrule_code_num BETWEEN 609 AND 617)
	WHEN {{location}} = 'Framingham State' THEN (f.loanrule_code_num BETWEEN 145 AND 155 OR f.loanrule_code_num BETWEEN 618 AND 626)
	WHEN {{location}} = 'Holliston' THEN (f.loanrule_code_num BETWEEN 156 AND 166 OR f.loanrule_code_num BETWEEN 627 AND 635)
	WHEN {{location}} = 'Lasell' THEN (f.loanrule_code_num BETWEEN 167 AND 177 OR f.loanrule_code_num BETWEEN 636 AND 644)
	WHEN {{location}} = 'Lexington' THEN (f.loanrule_code_num BETWEEN 178 AND 188 OR f.loanrule_code_num BETWEEN 645 AND 653) 
	WHEN {{location}} = 'Lincoln' THEN (f.loanrule_code_num BETWEEN 189 AND 199 OR f.loanrule_code_num BETWEEN 654 AND 662)
	WHEN {{location}} = 'Maynard' THEN (f.loanrule_code_num BETWEEN 200 AND 210 OR f.loanrule_code_num BETWEEN 663 AND 671)
	WHEN {{location}} = 'Medford' THEN (f.loanrule_code_num BETWEEN 222 AND 232 OR f.loanrule_code_num BETWEEN 681 AND 689) 
	WHEN {{location}} = 'Millis' THEN (f.loanrule_code_num BETWEEN 233 AND 243 OR f.loanrule_code_num BETWEEN 690 AND 698) 
	WHEN {{location}} = 'Medfield' THEN (f.loanrule_code_num BETWEEN 244 AND 254 OR f.loanrule_code_num BETWEEN 699 AND 707)
	WHEN {{location}} = 'Medway' THEN (f.loanrule_code_num BETWEEN 266 AND 276 OR f.loanrule_code_num BETWEEN 717 AND 725) 
	WHEN {{location}} = 'Natick' THEN (f.loanrule_code_num BETWEEN 277 AND 287 OR f.loanrule_code_num BETWEEN 726 AND 734)
	WHEN {{location}} = 'Needham' THEN( f.loanrule_code_num BETWEEN 299 AND 309 OR f.loanrule_code_num BETWEEN 744 AND 752) 
	WHEN {{location}} = 'Norwood' THEN (f.loanrule_code_num BETWEEN 310 AND 320 OR f.loanrule_code_num BETWEEN 753 AND 761) 
	WHEN {{location}} = 'Newton' THEN (f.loanrule_code_num BETWEEN 321 AND 331 OR f.loanrule_code_num BETWEEN 762 AND 770) 
	WHEN {{location}} = 'Olin' THEN (f.loanrule_code_num BETWEEN 289 AND 298 OR f.loanrule_code_num BETWEEN 734 AND 743)
	WHEN {{location}} = 'Somerville' THEN (f.loanrule_code_num BETWEEN 332 AND 342 OR f.loanrule_code_num BETWEEN 771 AND 779) 
	WHEN {{location}} = 'Stow' THEN (f.loanrule_code_num BETWEEN 343 AND 353 OR f.loanrule_code_num BETWEEN 780 AND 788) 
	WHEN {{location}} = 'Sudbury' THEN (f.loanrule_code_num BETWEEN 354 AND 364 OR f.loanrule_code_num BETWEEN 789 AND 797)
	WHEN {{location}} = 'Watertown' THEN (f.loanrule_code_num BETWEEN 365 AND 375 OR f.loanrule_code_num BETWEEN 798 AND 806) 
	WHEN {{location}} = 'Wellesley' THEN (f.loanrule_code_num BETWEEN 376 AND 386 OR f.loanrule_code_num BETWEEN 807 AND 815) 
	WHEN {{location}} = 'Winchester' THEN (f.loanrule_code_num BETWEEN 387 AND 397 OR f.loanrule_code_num BETWEEN 816 AND 824) 
	WHEN {{location}} = 'Waltham' THEN (f.loanrule_code_num BETWEEN 398 AND 408 OR f.loanrule_code_num BETWEEN 825 AND 833) 
	WHEN {{location}} = 'Woburn' THEN (f.loanrule_code_num BETWEEN 409 AND 419 OR f.loanrule_code_num BETWEEN 834 AND 842)
	WHEN {{location}} = 'Weston' THEN (f.loanrule_code_num BETWEEN 420 AND 430 OR f.loanrule_code_num BETWEEN 843 AND 851) 
	WHEN {{location}} = 'Westwood' THEN (f.loanrule_code_num BETWEEN 431 AND 441 OR f.loanrule_code_num BETWEEN 852 AND 860) 
	WHEN {{location}} = 'Wayland' THEN (f.loanrule_code_num BETWEEN 442 AND 452 OR f.loanrule_code_num BETWEEN 861 AND 869) 
	WHEN {{location}} = 'Pine Manor' THEN (f.loanrule_code_num BETWEEN 453 AND 463 OR f.loanrule_code_num BETWEEN 870 AND 878) 
	WHEN {{location}} = 'Regis' THEN (f.loanrule_code_num BETWEEN 464 AND 474 OR f.loanrule_code_num BETWEEN 879 AND 887) 
	WHEN {{location}} = 'Sherborn' THEN (f.loanrule_code_num BETWEEN 475 AND 485 OR f.loanrule_code_num BETWEEN 888 AND 896)
ELSE f.loanrule_code_num = 0
END

GROUP BY 1,4,5,6,7,8,9