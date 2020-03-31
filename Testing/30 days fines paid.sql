SELECT
d.all_dates AS paid_date,
CASE
WHEN fp.loan_rule_code_num BETWEEN 2 AND 12 OR fp.loan_rule_code_num BETWEEN 501 AND 509 THEN 'Acton'
WHEN fp.loan_rule_code_num BETWEEN 13 AND 23 OR fp.loan_rule_code_num BETWEEN 510 AND 518 THEN 'Arlington'
WHEN fp.loan_rule_code_num BETWEEN 24 AND 34 OR fp.loan_rule_code_num BETWEEN 519 AND 527 THEN 'Ashland'
WHEN fp.loan_rule_code_num BETWEEN 35 AND 45 OR fp.loan_rule_code_num BETWEEN 528 AND 536 THEN 'Bedford'
WHEN fp.loan_rule_code_num BETWEEN 46 AND 56 OR fp.loan_rule_code_num BETWEEN 537 AND 545 THEN 'Belmont'
WHEN fp.loan_rule_code_num BETWEEN 57 AND 67 OR fp.loan_rule_code_num BETWEEN 546 AND 554 THEN 'Brookline'
WHEN fp.loan_rule_code_num BETWEEN 68 AND 78 OR fp.loan_rule_code_num BETWEEN 555 AND 563 THEN 'Cambridge'
WHEN fp.loan_rule_code_num BETWEEN 79 AND 89 OR fp.loan_rule_code_num BETWEEN 564 AND 572 THEN 'Concord'
WHEN fp.loan_rule_code_num BETWEEN 90 AND 100 OR fp.loan_rule_code_num BETWEEN 573 AND 581 THEN 'Dedham'
WHEN fp.loan_rule_code_num BETWEEN 101 AND 111 OR fp.loan_rule_code_num BETWEEN 582 AND 590 THEN 'Dean'
WHEN fp.loan_rule_code_num BETWEEN 112 AND 122 OR fp.loan_rule_code_num BETWEEN 591 AND 599 THEN 'Dover'
WHEN fp.loan_rule_code_num BETWEEN 123 AND 133 OR fp.loan_rule_code_num BETWEEN 600 AND 608 THEN 'Framingham'
WHEN fp.loan_rule_code_num BETWEEN 134 AND 144 OR fp.loan_rule_code_num BETWEEN 609 AND 617 THEN 'Franklin'
WHEN fp.loan_rule_code_num BETWEEN 145 AND 155 OR fp.loan_rule_code_num BETWEEN 618 AND 626 THEN 'Framingham State'
WHEN fp.loan_rule_code_num BETWEEN 156 AND 166 OR fp.loan_rule_code_num BETWEEN 627 AND 635 THEN 'Holliston'
WHEN fp.loan_rule_code_num BETWEEN 167 AND 177 OR fp.loan_rule_code_num BETWEEN 636 AND 644 THEN 'Lasell'
WHEN fp.loan_rule_code_num BETWEEN 178 AND 188 OR fp.loan_rule_code_num BETWEEN 645 AND 653 THEN 'Lexington'
WHEN fp.loan_rule_code_num BETWEEN 189 AND 199 OR fp.loan_rule_code_num BETWEEN 654 AND 662 THEN 'Lincoln'
WHEN fp.loan_rule_code_num BETWEEN 200 AND 210 OR fp.loan_rule_code_num BETWEEN 663 AND 671 THEN 'Maynard'
WHEN fp.loan_rule_code_num BETWEEN 222 AND 232 OR fp.loan_rule_code_num BETWEEN 681 AND 689 THEN 'Medford'
WHEN fp.loan_rule_code_num BETWEEN 233 AND 243 OR fp.loan_rule_code_num BETWEEN 690 AND 698 THEN 'Millis'
WHEN fp.loan_rule_code_num BETWEEN 244 AND 254 OR fp.loan_rule_code_num BETWEEN 699 AND 707 THEN 'Medfield'
WHEN fp.loan_rule_code_num BETWEEN 255 AND 265 OR fp.loan_rule_code_num BETWEEN 708 AND 716 THEN 'Mount Ida'
WHEN fp.loan_rule_code_num BETWEEN 266 AND 276 OR fp.loan_rule_code_num BETWEEN 717 AND 725 THEN 'Medway'
WHEN fp.loan_rule_code_num BETWEEN 277 AND 287 OR fp.loan_rule_code_num BETWEEN 726 AND 734 THEN 'Natick'
WHEN fp.loan_rule_code_num BETWEEN 299 AND 309 OR fp.loan_rule_code_num BETWEEN 744 AND 752 THEN 'Needham'
WHEN fp.loan_rule_code_num BETWEEN 310 AND 320 OR fp.loan_rule_code_num BETWEEN 753 AND 761 THEN 'Norwood'
WHEN fp.loan_rule_code_num BETWEEN 321 AND 331 OR fp.loan_rule_code_num BETWEEN 762 AND 770 THEN 'Newton'
WHEN fp.loan_rule_code_num BETWEEN 332 AND 342 OR fp.loan_rule_code_num BETWEEN 771 AND 779 THEN 'Somerville'
WHEN fp.loan_rule_code_num BETWEEN 343 AND 353 OR fp.loan_rule_code_num BETWEEN 780 AND 788 THEN 'Stow'
WHEN fp.loan_rule_code_num BETWEEN 354 AND 364 OR fp.loan_rule_code_num BETWEEN 789 AND 797 THEN 'Sudbury'
WHEN fp.loan_rule_code_num BETWEEN 365 AND 375 OR fp.loan_rule_code_num BETWEEN 798 AND 806 THEN 'Watertown'
WHEN fp.loan_rule_code_num BETWEEN 376 AND 386 OR fp.loan_rule_code_num BETWEEN 807 AND 815 THEN 'Wellesley'
WHEN fp.loan_rule_code_num BETWEEN 387 AND 397 OR fp.loan_rule_code_num BETWEEN 816 AND 824 THEN 'Winchester'
WHEN fp.loan_rule_code_num BETWEEN 398 AND 408 OR fp.loan_rule_code_num BETWEEN 825 AND 833 THEN 'Waltham'
WHEN fp.loan_rule_code_num BETWEEN 409 AND 419 OR fp.loan_rule_code_num BETWEEN 834 AND 842 THEN 'Woburn'
WHEN fp.loan_rule_code_num BETWEEN 420 AND 430 OR fp.loan_rule_code_num BETWEEN 843 AND 851 THEN 'Weston'
WHEN fp.loan_rule_code_num BETWEEN 431 AND 441 OR fp.loan_rule_code_num BETWEEN 852 AND 860 THEN 'Westwood'
WHEN fp.loan_rule_code_num BETWEEN 442 AND 452 OR fp.loan_rule_code_num BETWEEN 861 AND 869 THEN 'Wayland'
WHEN fp.loan_rule_code_num BETWEEN 453 AND 463 OR fp.loan_rule_code_num BETWEEN 870 AND 878 THEN 'Pine Manor'
WHEN fp.loan_rule_code_num BETWEEN 464 AND 474 OR fp.loan_rule_code_num BETWEEN 879 AND 887 THEN 'Regis'
WHEN fp.loan_rule_code_num BETWEEN 475 AND 485 OR fp.loan_rule_code_num BETWEEN 888 AND 896 THEN 'Sherborn'
Else 'Other'
END AS checkout_location,
COUNT(fp.id) FILTER (WHERE fp.payment_status_code NOT IN ('3','0')) AS fines_paid_count,
COUNT(fp.id) FILTER (WHERE fp.payment_status_code = '3') AS fines_waived_count,
COUNT(fp.id) FILTER (WHERE fp.payment_status_code = '0') AS fines_removed_count,
COALESCE(SUM(
CASE
	WHEN fp.payment_status_code = '2' THEN fp.paid_now_amt
	ELSE fp.item_charge_amt + fp.processing_fee_amt + fp.processing_fee_amt
END
) FILTER (WHERE fp.payment_status_code != '3'),'0')::MONEY AS fines_paid_total,
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
fp.paid_date_gmt::DATE >= NOW()::DATE - INTERVAL '1 month'
AND fp.charge_type_code IN ('1','2','3','4','5','6')

GROUP BY 1,2