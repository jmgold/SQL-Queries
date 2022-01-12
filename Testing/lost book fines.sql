WITH checkout_loc AS (
SELECT
f.id,
CASE
WHEN f.loanrule_code_num BETWEEN 2 AND 12 OR f.loanrule_code_num BETWEEN 501 AND 509 THEN 'act'
WHEN f.loanrule_code_num BETWEEN 13 AND 23 OR f.loanrule_code_num BETWEEN 510 AND 518 THEN 'arl'
WHEN f.loanrule_code_num BETWEEN 24 AND 34 OR f.loanrule_code_num BETWEEN 519 AND 527 THEN 'ash'
WHEN f.loanrule_code_num BETWEEN 35 AND 45 OR f.loanrule_code_num BETWEEN 528 AND 536 THEN 'bed'
WHEN f.loanrule_code_num BETWEEN 46 AND 56 OR f.loanrule_code_num BETWEEN 537 AND 545 THEN 'blm'
WHEN f.loanrule_code_num BETWEEN 57 AND 67 OR f.loanrule_code_num BETWEEN 546 AND 554 THEN 'brk'
WHEN f.loanrule_code_num BETWEEN 68 AND 78 OR f.loanrule_code_num BETWEEN 555 AND 563 THEN 'cam'
WHEN f.loanrule_code_num BETWEEN 79 AND 89 OR f.loanrule_code_num BETWEEN 564 AND 572 THEN 'con'
WHEN f.loanrule_code_num BETWEEN 90 AND 100 OR f.loanrule_code_num BETWEEN 573 AND 581 THEN 'ddm'
WHEN f.loanrule_code_num BETWEEN 101 AND 111 OR f.loanrule_code_num BETWEEN 582 AND 590 THEN 'dea'
WHEN f.loanrule_code_num BETWEEN 112 AND 122 OR f.loanrule_code_num BETWEEN 591 AND 599 THEN 'dov'
WHEN f.loanrule_code_num BETWEEN 123 AND 133 OR f.loanrule_code_num BETWEEN 600 AND 608 THEN 'fpl'
WHEN f.loanrule_code_num BETWEEN 134 AND 144 OR f.loanrule_code_num BETWEEN 609 AND 617 THEN 'frk'
WHEN f.loanrule_code_num BETWEEN 145 AND 155 OR f.loanrule_code_num BETWEEN 618 AND 626 THEN 'fst'
WHEN f.loanrule_code_num BETWEEN 156 AND 166 OR f.loanrule_code_num BETWEEN 627 AND 635 THEN 'hol'
WHEN f.loanrule_code_num BETWEEN 167 AND 177 OR f.loanrule_code_num BETWEEN 636 AND 644 THEN 'las'
WHEN f.loanrule_code_num BETWEEN 178 AND 188 OR f.loanrule_code_num BETWEEN 645 AND 653 THEN 'lex'
WHEN f.loanrule_code_num BETWEEN 189 AND 199 OR f.loanrule_code_num BETWEEN 654 AND 662 THEN 'lin'
WHEN f.loanrule_code_num BETWEEN 200 AND 210 OR f.loanrule_code_num BETWEEN 663 AND 671 THEN 'may'
WHEN f.loanrule_code_num BETWEEN 222 AND 232 OR f.loanrule_code_num BETWEEN 681 AND 689 THEN 'med'
WHEN f.loanrule_code_num BETWEEN 233 AND 243 OR f.loanrule_code_num BETWEEN 690 AND 698 THEN 'mil'
WHEN f.loanrule_code_num BETWEEN 244 AND 254 OR f.loanrule_code_num BETWEEN 699 AND 707 THEN 'mld'
WHEN f.loanrule_code_num BETWEEN 255 AND 265 OR f.loanrule_code_num BETWEEN 708 AND 716 THEN 'mti'
WHEN f.loanrule_code_num BETWEEN 266 AND 276 OR f.loanrule_code_num BETWEEN 717 AND 725 THEN 'mwy'
WHEN f.loanrule_code_num BETWEEN 277 AND 287 OR f.loanrule_code_num BETWEEN 726 AND 733 THEN 'nat'
WHEN f.loanrule_code_num BETWEEN 289 AND 298 OR f.loanrule_code_num BETWEEN 734 AND 743 THEN 'oln'
WHEN f.loanrule_code_num BETWEEN 299 AND 309 OR f.loanrule_code_num BETWEEN 744 AND 752 THEN 'nee'
WHEN f.loanrule_code_num BETWEEN 310 AND 320 OR f.loanrule_code_num BETWEEN 753 AND 761 THEN 'nor'
WHEN f.loanrule_code_num BETWEEN 321 AND 331 OR f.loanrule_code_num BETWEEN 762 AND 770 THEN 'ntn'
WHEN f.loanrule_code_num BETWEEN 332 AND 342 OR f.loanrule_code_num BETWEEN 771 AND 779 THEN 'som'
WHEN f.loanrule_code_num BETWEEN 343 AND 353 OR f.loanrule_code_num BETWEEN 780 AND 788 THEN 'sto'
WHEN f.loanrule_code_num BETWEEN 354 AND 364 OR f.loanrule_code_num BETWEEN 789 AND 797 THEN 'sud'
WHEN f.loanrule_code_num BETWEEN 365 AND 375 OR f.loanrule_code_num BETWEEN 798 AND 806 THEN 'wat'
WHEN f.loanrule_code_num BETWEEN 376 AND 386 OR f.loanrule_code_num BETWEEN 807 AND 815 THEN 'wel'
WHEN f.loanrule_code_num BETWEEN 387 AND 397 OR f.loanrule_code_num BETWEEN 816 AND 824 THEN 'win'
WHEN f.loanrule_code_num BETWEEN 398 AND 408 OR f.loanrule_code_num BETWEEN 825 AND 833 THEN 'wlm'
WHEN f.loanrule_code_num BETWEEN 409 AND 419 OR f.loanrule_code_num BETWEEN 834 AND 842 THEN 'wob'
WHEN f.loanrule_code_num BETWEEN 420 AND 430 OR f.loanrule_code_num BETWEEN 843 AND 851 THEN 'wsn'
WHEN f.loanrule_code_num BETWEEN 431 AND 441 OR f.loanrule_code_num BETWEEN 852 AND 860 THEN 'wwd'
WHEN f.loanrule_code_num BETWEEN 442 AND 452 OR f.loanrule_code_num BETWEEN 861 AND 869 THEN 'wyl'
WHEN f.loanrule_code_num BETWEEN 453 AND 463 OR f.loanrule_code_num BETWEEN 870 AND 878 THEN 'pmc'
WHEN f.loanrule_code_num BETWEEN 464 AND 474 OR f.loanrule_code_num BETWEEN 879 AND 887 THEN 'reg'
WHEN f.loanrule_code_num BETWEEN 475 AND 485 OR f.loanrule_code_num BETWEEN 888 AND 896 THEN 'shr'
Else 'Other'
END AS checkout_location
FROM
sierra_view.fine f
)

SELECT
c.checkout_location,
COUNT(DISTINCT f.id) AS lost_item_total,
COUNT(DISTINCT f.id) FILTER(WHERE SUBSTRING(c.checkout_location,1,2) != SUBSTRING(f.charge_location_code,1,2)) AS lost_item_non_local,
COUNT(DISTINCT f.id) FILTER(WHERE f.assessed_gmt::DATE >= '2020-03-01') AS lost_item_pandemic,
COUNT(DISTINCT f.id) FILTER(WHERE SUBSTRING(c.checkout_location,1,2) != SUBSTRING(f.charge_location_code,1,2) AND f.assessed_gmt::DATE >= '2020-03-01') AS lost_item_non_local_pandemic

FROM
sierra_view.fine f
JOIN
checkout_loc c
ON
f.id = c.id

WHERE
f.charge_code = '3'

GROUP BY 1
ORDER BY 1