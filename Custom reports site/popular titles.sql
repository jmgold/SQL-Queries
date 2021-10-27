/*
Jeremy Goldstein
Minuteman Library Network

Gathers the top titles, grouped by a choice of performance metrics
*/
WITH hold_count AS
	(SELECT
	l.bib_record_id,
	COUNT(DISTINCT h.id) AS count_holds_on_title
	--reconciles bib,item and volume level holds

	FROM
	sierra_view.hold h
	JOIN
	sierra_view.bib_record_item_record_link l
	ON
	h.record_id = l.item_record_id OR h.record_id = l.bib_record_id

	GROUP BY 1
	HAVING
	COUNT(DISTINCT h.id) > 1
)

SELECT
'b'||mb.record_num||'a' AS bib_number,
b.best_title AS title,
b.best_author AS author,
b.publish_year,
{{grouping}},
/*
Grouping options
ROUND(AVG((CAST(((i.checkout_total + i.renewal_total) * loan.est_loan_period) AS NUMERIC (12,2))/(CURRENT_DATE - m.creation_date_gmt::DATE)) * 100),2) AS time_checked_out_pct
ROUND(CAST(SUM(i.checkout_total) + SUM(i.renewal_total) AS NUMERIC (12,2))/CAST(COUNT (i.id) AS NUMERIC (12,2)), 2) AS turnover
SUM(i.checkout_total + i.renewal_total) AS total_circulation
SUM(i.checkout_total) AS total_checkouts
SUM(i.year_to_date_checkout_total) AS total_year_to_date_checkouts
SUM(i.last_year_to_date_checkout_total) AS total_last_year_to_date_checkouts
COALESCE(h.count_holds_on_title,0) AS total_holds
SUM(i.year_to_date_checkout_total + i.last_year_to_date_checkout_total) AS checkout_total
*/
COUNT (i.id) AS item_total

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
i.id = l.item_record_id AND i.location_code ~ '{{location}}' 
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
AND i.item_status_code NOT IN ({{item_status_codes}})
AND {{age_level}}
	/*
	SUBSTRING(i.location_code,4,1) NOT IN ('y','j') --adult
	SUBSTRING(i.location_code,4,1) = 'j' --juv
	SUBSTRING(i.location_code,4,1) = 'y' --ya
	i.location_code ~ '\w' --all
	*/
JOIN
sierra_view.record_metadata m
ON
i.id = m.id
JOIN
sierra_view.bib_record br
ON
l.bib_record_id = br.id
AND br.bcode3 NOT IN ('g','o','r','z','l','q','n')
JOIN
sierra_view.record_metadata mb
ON
b.bib_record_id = mb.id
LEFT JOIN
hold_count AS h
ON
b.bib_record_id = h.bib_record_id
JOIN
(
SELECT
i.itype_code_num,
ROUND(AVG(EXTRACT (DAY FROM l.est_loan_period))) AS est_loan_period

FROM
sierra_view.checkout c
JOIN (SELECT
CASE
WHEN f.loanrule_code_num BETWEEN 2 AND 12 OR f.loanrule_code_num BETWEEN 501 AND 509 THEN 'Acton'
WHEN f.loanrule_code_num BETWEEN 13 AND 23 OR f.loanrule_code_num BETWEEN 510 AND 518 THEN 'Arlington'
WHEN f.loanrule_code_num BETWEEN 24 AND 34 OR f.loanrule_code_num BETWEEN 519 AND 527 THEN 'Ashland'
WHEN f.loanrule_code_num BETWEEN 35 AND 45 OR f.loanrule_code_num BETWEEN 528 AND 536 THEN 'Bedford'
WHEN f.loanrule_code_num BETWEEN 46 AND 56 OR f.loanrule_code_num BETWEEN 537 AND 545 THEN 'Belmont'
WHEN f.loanrule_code_num BETWEEN 57 AND 67 OR f.loanrule_code_num BETWEEN 546 AND 554 THEN 'Brookline'
WHEN f.loanrule_code_num BETWEEN 68 AND 78 OR f.loanrule_code_num BETWEEN 555 AND 563 THEN 'Cambridge'
WHEN f.loanrule_code_num BETWEEN 79 AND 89 OR f.loanrule_code_num BETWEEN 564 AND 572 THEN 'Concord'
WHEN f.loanrule_code_num BETWEEN 90 AND 100 OR f.loanrule_code_num BETWEEN 573 AND 581 THEN 'Dedham'
WHEN f.loanrule_code_num BETWEEN 101 AND 111 OR f.loanrule_code_num BETWEEN 582 AND 590 THEN 'Dean'
WHEN f.loanrule_code_num BETWEEN 112 AND 122 OR f.loanrule_code_num BETWEEN 591 AND 599 THEN 'Dover'
WHEN f.loanrule_code_num BETWEEN 123 AND 133 OR f.loanrule_code_num BETWEEN 600 AND 608 THEN 'Framingham'
WHEN f.loanrule_code_num BETWEEN 134 AND 144 OR f.loanrule_code_num BETWEEN 609 AND 617 THEN 'Franklin'
WHEN f.loanrule_code_num BETWEEN 145 AND 155 OR f.loanrule_code_num BETWEEN 618 AND 626 THEN 'Framingham State'
WHEN f.loanrule_code_num BETWEEN 156 AND 166 OR f.loanrule_code_num BETWEEN 627 AND 635 THEN 'Holliston'
WHEN f.loanrule_code_num BETWEEN 167 AND 177 OR f.loanrule_code_num BETWEEN 636 AND 644 THEN 'Lasell'
WHEN f.loanrule_code_num BETWEEN 178 AND 188 OR f.loanrule_code_num BETWEEN 645 AND 653 THEN 'Lexington'
WHEN f.loanrule_code_num BETWEEN 189 AND 199 OR f.loanrule_code_num BETWEEN 654 AND 662 THEN 'Lincoln'
WHEN f.loanrule_code_num BETWEEN 200 AND 210 OR f.loanrule_code_num BETWEEN 663 AND 671 THEN 'Maynard'
WHEN f.loanrule_code_num BETWEEN 222 AND 232 OR f.loanrule_code_num BETWEEN 681 AND 689 THEN 'Medford'
WHEN f.loanrule_code_num BETWEEN 233 AND 243 OR f.loanrule_code_num BETWEEN 690 AND 698 THEN 'Millis'
WHEN f.loanrule_code_num BETWEEN 244 AND 254 OR f.loanrule_code_num BETWEEN 699 AND 707 THEN 'Medfield'
WHEN f.loanrule_code_num BETWEEN 255 AND 265 OR f.loanrule_code_num BETWEEN 708 AND 716 THEN 'Mount Ida'
WHEN f.loanrule_code_num BETWEEN 266 AND 276 OR f.loanrule_code_num BETWEEN 717 AND 725 THEN 'Medway'
WHEN f.loanrule_code_num BETWEEN 277 AND 287 OR f.loanrule_code_num BETWEEN 726 AND 733 THEN 'Natick'
WHEN f.loanrule_code_num BETWEEN 289 AND 298 OR f.loanrule_code_num BETWEEN 734 AND 743 THEN 'Olin'
WHEN f.loanrule_code_num BETWEEN 299 AND 309 OR f.loanrule_code_num BETWEEN 744 AND 752 THEN 'Needham'
WHEN f.loanrule_code_num BETWEEN 310 AND 320 OR f.loanrule_code_num BETWEEN 753 AND 761 THEN 'Norwood'
WHEN f.loanrule_code_num BETWEEN 321 AND 331 OR f.loanrule_code_num BETWEEN 762 AND 770 THEN 'Newton'
WHEN f.loanrule_code_num BETWEEN 332 AND 342 OR f.loanrule_code_num BETWEEN 771 AND 779 THEN 'Somerville'
WHEN f.loanrule_code_num BETWEEN 343 AND 353 OR f.loanrule_code_num BETWEEN 780 AND 788 THEN 'Stow'
WHEN f.loanrule_code_num BETWEEN 354 AND 364 OR f.loanrule_code_num BETWEEN 789 AND 797 THEN 'Sudbury'
WHEN f.loanrule_code_num BETWEEN 365 AND 375 OR f.loanrule_code_num BETWEEN 798 AND 806 THEN 'Watertown'
WHEN f.loanrule_code_num BETWEEN 376 AND 386 OR f.loanrule_code_num BETWEEN 807 AND 815 THEN 'Wellesley'
WHEN f.loanrule_code_num BETWEEN 387 AND 397 OR f.loanrule_code_num BETWEEN 816 AND 824 THEN 'Winchester'
WHEN f.loanrule_code_num BETWEEN 398 AND 408 OR f.loanrule_code_num BETWEEN 825 AND 833 THEN 'Waltham'
WHEN f.loanrule_code_num BETWEEN 409 AND 419 OR f.loanrule_code_num BETWEEN 834 AND 842 THEN 'Woburn'
WHEN f.loanrule_code_num BETWEEN 420 AND 430 OR f.loanrule_code_num BETWEEN 843 AND 851 THEN 'Weston'
WHEN f.loanrule_code_num BETWEEN 431 AND 441 OR f.loanrule_code_num BETWEEN 852 AND 860 THEN 'Westwood'
WHEN f.loanrule_code_num BETWEEN 442 AND 452 OR f.loanrule_code_num BETWEEN 861 AND 869 THEN 'Wayland'
WHEN f.loanrule_code_num BETWEEN 453 AND 463 OR f.loanrule_code_num BETWEEN 870 AND 878 THEN 'Pine Manor'
WHEN f.loanrule_code_num BETWEEN 464 AND 474 OR f.loanrule_code_num BETWEEN 879 AND 887 THEN 'Regis'
WHEN f.loanrule_code_num BETWEEN 475 AND 485 OR f.loanrule_code_num BETWEEN 888 AND 896 THEN 'Sherborn'
Else 'Other'
END AS checkout_location,
f.loanrule_code_num AS loanrule_num,
MIN(AGE(f.due_gmt::date,f.checkout_gmt::date)) AS est_loan_period

FROM
sierra_view.fine f
WHERE f.loanrule_code_num NOT IN ('1','288','493','494','495','496','497','498','999')
GROUP BY 1,2
HAVING COUNT(f.loanrule_code_num) > 5
ORDER BY 1,2
) l
ON
c.loanrule_code_num = l.loanrule_num
JOIN
sierra_view.item_record i
ON
c.item_record_id = i.id

GROUP BY 1) loan
ON
i.itype_code_num = loan.itype_code_num

WHERE
b.material_code IN ({{mat_type}})
AND m.creation_date_gmt::DATE < {{created_date}}

GROUP BY
2,3,1,4,h.count_holds_on_title
ORDER BY 5 DESC
LIMIT {{qty}}