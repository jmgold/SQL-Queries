/*
Jeremy Goldstien
Minuteman Library Network

Generates a crosstab report comparing the checkin and checkout locations for each item returned in the past month.
*/

--start of checkins with different location than checkout
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
DISTINCT l.name AS checkout_location,
COUNT(C.id) AS checkin_total,
COUNT(C.id) FILTER (WHERE SUBSTRING(s.location_code,1,2) != cl.checkout_location) AS checked_out_elsewhere,
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '100' AND '109') AS "ACTON",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '110' AND '129') AS "ARLINGTON",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '130' AND '139') AS "ASHLAND",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '140' AND '149') AS "BEDFORD",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '150' AND '179') AS "BELMONT",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '180' AND '209') AS "BROOKLINE",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '210' AND '299') AS "CAMBRIDGE",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '300' AND '319') AS "CONCORD",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '340' AND '349') AS "DEAN",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '320' AND '339') AS "DEDHAM",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '350' AND '359') AS "DOVER",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '360' AND '379') AS "FRAMINGHAM",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '390' AND '399') AS "FRAMINGHAM STATE",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '380' AND '389') AS "FRANKLIN",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '400' AND '409') AS "HOLLISTON",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '410' AND '419') AS "LASELL UNIVERSITY",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '420' AND '439') AS "LEXINGTON",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '440' AND '449') AS "LINCOLN",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '450' AND '459') AS "MAYNARD",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '500' AND '509') AS "MEDFIELD",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '480' AND '489') AS "MEDFORD",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '520' AND '529') AS "MEDWAY",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '490' AND '499') AS "MILLIS",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '530' AND '559') AS "NATICK",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '570' AND '579') AS "NEEDHAM",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '590' AND '599') AS "NEWTON",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '580' AND '589') AS "NORWOOD",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '620' AND '629') AS "OLIN",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '830' AND '839') AS "PINE MANOR COLLEGE",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '840' AND '849') AS "REGIS",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '850' AND '859') AS "SHERBORN",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '640' AND '679') AS "SOMERVILLE",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '680' AND '689') AS "STOW",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '690' AND '699') AS "SUDBURY",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '700' AND '709') AS "WALTHAM",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '710' AND '739') AS "WATERTOWN",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '740' AND '749') AS "WAYLAND",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '750' AND '779') AS "WELLESLEY",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '800' AND '809') AS "WESTON",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '810' AND '829') AS "WESTWOOD",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '780' AND '789') AS "WINCHESTER",
COUNT(C.id) FILTER (WHERE C.stat_group_code_num BETWEEN '790' AND '799') AS "WOBURN"

FROM
sierra_view.circ_trans C
JOIN
sierra_view.statistic_group_myuser s
ON
C.stat_group_code_num = s.code
JOIN
checkout_location cl
ON
C.id = cl.id
JOIN
sierra_view.location_myuser l
ON
cl.checkout_location = SUBSTRING(l.code,1,2) AND l.code ~ '^[a-z]{3}$' AND l.code != 'mls'

WHERE
C.op_code = 'i'
AND C.transaction_gmt::DATE >= NOW()::DATE - INTERVAL '1 MONTH'

GROUP BY 1
ORDER BY 1
