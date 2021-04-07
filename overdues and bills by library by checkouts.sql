WITH patron_count AS (
SELECT
l.name AS home_library,COUNT(p.id) AS total_patrons
FROM
sierra_view.patron_record p
JOIN
sierra_view.location_myuser l
ON
SUBSTRING(p.home_library_code,1,3) = l.code


GROUP BY 1
)

SELECT
CASE
WHEN o.loanrule_code_num BETWEEN 2 AND 12 OR o.loanrule_code_num BETWEEN 501 AND 509 THEN 'Acton'
WHEN o.loanrule_code_num BETWEEN 13 AND 23 OR o.loanrule_code_num BETWEEN 510 AND 518 THEN 'Arlington'
WHEN o.loanrule_code_num BETWEEN 24 AND 34 OR o.loanrule_code_num BETWEEN 519 AND 527 THEN 'Ashland'
WHEN o.loanrule_code_num BETWEEN 35 AND 45 OR o.loanrule_code_num BETWEEN 528 AND 536 THEN 'Bedford'
WHEN o.loanrule_code_num BETWEEN 46 AND 56 OR o.loanrule_code_num BETWEEN 537 AND 545 THEN 'Belmont'
WHEN o.loanrule_code_num BETWEEN 57 AND 67 OR o.loanrule_code_num BETWEEN 546 AND 554 THEN 'Brookline'
WHEN o.loanrule_code_num BETWEEN 68 AND 78 OR o.loanrule_code_num BETWEEN 555 AND 563 THEN 'Cambridge'
WHEN o.loanrule_code_num BETWEEN 79 AND 89 OR o.loanrule_code_num BETWEEN 564 AND 572 THEN 'Concord'
WHEN o.loanrule_code_num BETWEEN 90 AND 100 OR o.loanrule_code_num BETWEEN 573 AND 581 THEN 'Dedham'
WHEN o.loanrule_code_num BETWEEN 101 AND 111 OR o.loanrule_code_num BETWEEN 582 AND 590 THEN 'Dean'
WHEN o.loanrule_code_num BETWEEN 112 AND 122 OR o.loanrule_code_num BETWEEN 591 AND 599 THEN 'Dover'
WHEN o.loanrule_code_num BETWEEN 123 AND 133 OR o.loanrule_code_num BETWEEN 600 AND 608 THEN 'Framingham'
WHEN o.loanrule_code_num BETWEEN 134 AND 144 OR o.loanrule_code_num BETWEEN 609 AND 617 THEN 'Franklin'
WHEN o.loanrule_code_num BETWEEN 145 AND 155 OR o.loanrule_code_num BETWEEN 618 AND 626 THEN 'Framingham State'
WHEN o.loanrule_code_num BETWEEN 156 AND 166 OR o.loanrule_code_num BETWEEN 627 AND 635 THEN 'Holliston'
WHEN o.loanrule_code_num BETWEEN 167 AND 177 OR o.loanrule_code_num BETWEEN 636 AND 644 THEN 'Lasell University'
WHEN o.loanrule_code_num BETWEEN 178 AND 188 OR o.loanrule_code_num BETWEEN 645 AND 653 THEN 'Lexington'
WHEN o.loanrule_code_num BETWEEN 189 AND 199 OR o.loanrule_code_num BETWEEN 654 AND 662 THEN 'Lincoln'
WHEN o.loanrule_code_num BETWEEN 200 AND 210 OR o.loanrule_code_num BETWEEN 663 AND 671 THEN 'Maynard'
WHEN o.loanrule_code_num BETWEEN 222 AND 232 OR o.loanrule_code_num BETWEEN 681 AND 689 THEN 'Medford'
WHEN o.loanrule_code_num BETWEEN 233 AND 243 OR o.loanrule_code_num BETWEEN 690 AND 698 THEN 'Millis'
WHEN o.loanrule_code_num BETWEEN 244 AND 254 OR o.loanrule_code_num BETWEEN 699 AND 707 THEN 'Medfield'
WHEN o.loanrule_code_num BETWEEN 255 AND 265 OR o.loanrule_code_num BETWEEN 708 AND 716 THEN 'Mount Ida'
WHEN o.loanrule_code_num BETWEEN 266 AND 276 OR o.loanrule_code_num BETWEEN 717 AND 725 THEN 'Medway'
WHEN o.loanrule_code_num BETWEEN 277 AND 287 OR o.loanrule_code_num BETWEEN 726 AND 734 THEN 'Natick'
WHEN o.loanrule_code_num BETWEEN 299 AND 309 OR o.loanrule_code_num BETWEEN 744 AND 752 THEN 'Needham'
WHEN o.loanrule_code_num BETWEEN 310 AND 320 OR o.loanrule_code_num BETWEEN 753 AND 761 THEN 'Norwood'
WHEN o.loanrule_code_num BETWEEN 321 AND 331 OR o.loanrule_code_num BETWEEN 762 AND 770 THEN 'Newton'
WHEN o.loanrule_code_num BETWEEN 289 AND 298 OR o.loanrule_code_num BETWEEN 734 AND 743 THEN 'Olin College'
WHEN o.loanrule_code_num BETWEEN 332 AND 342 OR o.loanrule_code_num BETWEEN 771 AND 779 THEN 'Somerville'
WHEN o.loanrule_code_num BETWEEN 343 AND 353 OR o.loanrule_code_num BETWEEN 780 AND 788 THEN 'Stow'
WHEN o.loanrule_code_num BETWEEN 354 AND 364 OR o.loanrule_code_num BETWEEN 789 AND 797 THEN 'Sudbury'
WHEN o.loanrule_code_num BETWEEN 365 AND 375 OR o.loanrule_code_num BETWEEN 798 AND 806 THEN 'Watertown'
WHEN o.loanrule_code_num BETWEEN 376 AND 386 OR o.loanrule_code_num BETWEEN 807 AND 815 THEN 'Wellesley'
WHEN o.loanrule_code_num BETWEEN 387 AND 397 OR o.loanrule_code_num BETWEEN 816 AND 824 THEN 'Winchester'
WHEN o.loanrule_code_num BETWEEN 398 AND 408 OR o.loanrule_code_num BETWEEN 825 AND 833 THEN 'Waltham'
WHEN o.loanrule_code_num BETWEEN 409 AND 419 OR o.loanrule_code_num BETWEEN 834 AND 842 THEN 'Woburn'
WHEN o.loanrule_code_num BETWEEN 420 AND 430 OR o.loanrule_code_num BETWEEN 843 AND 851 THEN 'Weston'
WHEN o.loanrule_code_num BETWEEN 431 AND 441 OR o.loanrule_code_num BETWEEN 852 AND 860 THEN 'Westwood'
WHEN o.loanrule_code_num BETWEEN 442 AND 452 OR o.loanrule_code_num BETWEEN 861 AND 869 THEN 'Wayland'
WHEN o.loanrule_code_num BETWEEN 453 AND 463 OR o.loanrule_code_num BETWEEN 870 AND 878 THEN 'Pine Manor College'
WHEN o.loanrule_code_num BETWEEN 464 AND 474 OR o.loanrule_code_num BETWEEN 879 AND 887 THEN 'Regis'
WHEN o.loanrule_code_num BETWEEN 475 AND 485 OR o.loanrule_code_num BETWEEN 888 AND 896 THEN 'Sherborn'
ELSE 'other'
END AS checkout_location,
SUM(DISTINCT p.total_patrons) AS total_patrons,
COUNT(DISTINCT o.patron_record_id) AS total_patrons_with_checkouts,
COUNT(DISTINCT o.patron_record_id) FILTER(WHERE i.item_status_code = 'n') total_patrons_billed_items,
COUNT(DISTINCT i.id) FILTER(WHERE i.item_status_code = 'n') AS billed_item_count,
SUM(i.price) FILTER(WHERE i.item_status_code = 'n')::MONEY AS billed_item_value,
COUNT(DISTINCT o.patron_record_id) FILTER (WHERE CURRENT_DATE - o.due_gmt::DATE > 60) AS total_over_60,
COUNT(DISTINCT o.patron_record_id) FILTER (WHERE CURRENT_DATE - o.due_gmt::DATE > 60 AND i.item_status_code != 'n' ) AS total_over_60_not_billed,
COUNT(DISTINCT o.patron_record_id) FILTER (WHERE CURRENT_DATE - o.due_gmt::DATE > 90) AS total_over_90,
COUNT(DISTINCT o.patron_record_id) FILTER (WHERE CURRENT_DATE - o.due_gmt::DATE > 90 AND i.item_status_code != 'n' ) AS total_over_90_not_billed,
COUNT(DISTINCT o.patron_record_id) FILTER (WHERE CURRENT_DATE - o.due_gmt::DATE > 180) AS total_over_180,
COUNT(DISTINCT o.patron_record_id) FILTER (WHERE CURRENT_DATE - o.due_gmt::DATE > 180 AND i.item_status_code != 'n' ) AS total_over_180_not_billed
FROM
sierra_view.checkout o
JOIN
sierra_view.item_record i
ON
o.item_record_id = i.id
LEFT JOIN
patron_count p
ON
CASE
WHEN o.loanrule_code_num BETWEEN 2 AND 12 OR o.loanrule_code_num BETWEEN 501 AND 509 THEN 'Acton'
WHEN o.loanrule_code_num BETWEEN 13 AND 23 OR o.loanrule_code_num BETWEEN 510 AND 518 THEN 'Arlington'
WHEN o.loanrule_code_num BETWEEN 24 AND 34 OR o.loanrule_code_num BETWEEN 519 AND 527 THEN 'Ashland'
WHEN o.loanrule_code_num BETWEEN 35 AND 45 OR o.loanrule_code_num BETWEEN 528 AND 536 THEN 'Bedford'
WHEN o.loanrule_code_num BETWEEN 46 AND 56 OR o.loanrule_code_num BETWEEN 537 AND 545 THEN 'Belmont'
WHEN o.loanrule_code_num BETWEEN 57 AND 67 OR o.loanrule_code_num BETWEEN 546 AND 554 THEN 'Brookline'
WHEN o.loanrule_code_num BETWEEN 68 AND 78 OR o.loanrule_code_num BETWEEN 555 AND 563 THEN 'Cambridge'
WHEN o.loanrule_code_num BETWEEN 79 AND 89 OR o.loanrule_code_num BETWEEN 564 AND 572 THEN 'Concord'
WHEN o.loanrule_code_num BETWEEN 90 AND 100 OR o.loanrule_code_num BETWEEN 573 AND 581 THEN 'Dedham'
WHEN o.loanrule_code_num BETWEEN 101 AND 111 OR o.loanrule_code_num BETWEEN 582 AND 590 THEN 'Dean College'
WHEN o.loanrule_code_num BETWEEN 112 AND 122 OR o.loanrule_code_num BETWEEN 591 AND 599 THEN 'Dover'
WHEN o.loanrule_code_num BETWEEN 123 AND 133 OR o.loanrule_code_num BETWEEN 600 AND 608 THEN 'Framingham'
WHEN o.loanrule_code_num BETWEEN 134 AND 144 OR o.loanrule_code_num BETWEEN 609 AND 617 THEN 'Franklin'
WHEN o.loanrule_code_num BETWEEN 145 AND 155 OR o.loanrule_code_num BETWEEN 618 AND 626 THEN 'Framingham State'
WHEN o.loanrule_code_num BETWEEN 156 AND 166 OR o.loanrule_code_num BETWEEN 627 AND 635 THEN 'Holliston'
WHEN o.loanrule_code_num BETWEEN 167 AND 177 OR o.loanrule_code_num BETWEEN 636 AND 644 THEN 'Lasell University'
WHEN o.loanrule_code_num BETWEEN 178 AND 188 OR o.loanrule_code_num BETWEEN 645 AND 653 THEN 'Lexington'
WHEN o.loanrule_code_num BETWEEN 189 AND 199 OR o.loanrule_code_num BETWEEN 654 AND 662 THEN 'Lincoln'
WHEN o.loanrule_code_num BETWEEN 200 AND 210 OR o.loanrule_code_num BETWEEN 663 AND 671 THEN 'Maynard'
WHEN o.loanrule_code_num BETWEEN 222 AND 232 OR o.loanrule_code_num BETWEEN 681 AND 689 THEN 'Medford'
WHEN o.loanrule_code_num BETWEEN 233 AND 243 OR o.loanrule_code_num BETWEEN 690 AND 698 THEN 'Millis'
WHEN o.loanrule_code_num BETWEEN 244 AND 254 OR o.loanrule_code_num BETWEEN 699 AND 707 THEN 'Medfield'
WHEN o.loanrule_code_num BETWEEN 255 AND 265 OR o.loanrule_code_num BETWEEN 708 AND 716 THEN 'Mount Ida'
WHEN o.loanrule_code_num BETWEEN 266 AND 276 OR o.loanrule_code_num BETWEEN 717 AND 725 THEN 'Medway'
WHEN o.loanrule_code_num BETWEEN 277 AND 287 OR o.loanrule_code_num BETWEEN 726 AND 734 THEN 'Natick'
WHEN o.loanrule_code_num BETWEEN 299 AND 309 OR o.loanrule_code_num BETWEEN 744 AND 752 THEN 'Needham'
WHEN o.loanrule_code_num BETWEEN 310 AND 320 OR o.loanrule_code_num BETWEEN 753 AND 761 THEN 'Norwood'
WHEN o.loanrule_code_num BETWEEN 321 AND 331 OR o.loanrule_code_num BETWEEN 762 AND 770 THEN 'Newton'
WHEN o.loanrule_code_num BETWEEN 289 AND 298 OR o.loanrule_code_num BETWEEN 734 AND 743 THEN 'Olin College'
WHEN o.loanrule_code_num BETWEEN 332 AND 342 OR o.loanrule_code_num BETWEEN 771 AND 779 THEN 'Somerville'
WHEN o.loanrule_code_num BETWEEN 343 AND 353 OR o.loanrule_code_num BETWEEN 780 AND 788 THEN 'Stow'
WHEN o.loanrule_code_num BETWEEN 354 AND 364 OR o.loanrule_code_num BETWEEN 789 AND 797 THEN 'Sudbury'
WHEN o.loanrule_code_num BETWEEN 365 AND 375 OR o.loanrule_code_num BETWEEN 798 AND 806 THEN 'Watertown'
WHEN o.loanrule_code_num BETWEEN 376 AND 386 OR o.loanrule_code_num BETWEEN 807 AND 815 THEN 'Wellesley'
WHEN o.loanrule_code_num BETWEEN 387 AND 397 OR o.loanrule_code_num BETWEEN 816 AND 824 THEN 'Winchester'
WHEN o.loanrule_code_num BETWEEN 398 AND 408 OR o.loanrule_code_num BETWEEN 825 AND 833 THEN 'Waltham'
WHEN o.loanrule_code_num BETWEEN 409 AND 419 OR o.loanrule_code_num BETWEEN 834 AND 842 THEN 'Woburn'
WHEN o.loanrule_code_num BETWEEN 420 AND 430 OR o.loanrule_code_num BETWEEN 843 AND 851 THEN 'Weston'
WHEN o.loanrule_code_num BETWEEN 431 AND 441 OR o.loanrule_code_num BETWEEN 852 AND 860 THEN 'Westwood'
WHEN o.loanrule_code_num BETWEEN 442 AND 452 OR o.loanrule_code_num BETWEEN 861 AND 869 THEN 'Wayland'
WHEN o.loanrule_code_num BETWEEN 453 AND 463 OR o.loanrule_code_num BETWEEN 870 AND 878 THEN 'Pine Manor College'
WHEN o.loanrule_code_num BETWEEN 464 AND 474 OR o.loanrule_code_num BETWEEN 879 AND 887 THEN 'Regis'
WHEN o.loanrule_code_num BETWEEN 475 AND 485 OR o.loanrule_code_num BETWEEN 888 AND 896 THEN 'Sherborn'
ELSE 'other'
END = INITCAP(SPLIT_PART(p.home_library,'/',1))


GROUP BY 1
ORDER BY 1
