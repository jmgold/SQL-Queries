WITH patrons AS (
SELECT
f.patron_record_id

FROM
sierra_view.fine f
JOIN
sierra_view.item_record i
ON
f.item_record_metadata_id = i.id AND  i.location_code ~ '^ca\w{1}(j|y)'
AND f.charge_code IN ('3','5')
GROUP BY 1
HAVING
COUNT(*) FILTER(WHERE f.assessed_gmt::DATE BETWEEN '2024-01-01' AND '2024-05-31') > 0
)

SELECT
f.assessed_gmt::DATE AS assessed_date,
rm.record_type_code||rm.record_num||'a' AS pnumber,
ip.barcode,
f.title,
f.item_charge_amt::MONEY AS charge_amt,
CASE 
	WHEN (f.loanrule_code_num BETWEEN 2 AND 12 OR f.loanrule_code_num BETWEEN 501 AND 509) THEN 'Acton'
	WHEN (f.loanrule_code_num BETWEEN 13 AND 23 OR f.loanrule_code_num BETWEEN 510 AND 518) THEN 'Arlington'
	WHEN (f.loanrule_code_num BETWEEN 24 AND 34 OR f.loanrule_code_num BETWEEN 519 AND 527) THEN 'Ashland'
	WHEN (f.loanrule_code_num BETWEEN 35 AND 45 OR f.loanrule_code_num BETWEEN 528 AND 536) THEN 'Bedford'
	WHEN (f.loanrule_code_num BETWEEN 46 AND 56 OR f.loanrule_code_num BETWEEN 537 AND 545) THEN 'Belmont'
	WHEN (f.loanrule_code_num BETWEEN 57 AND 67 OR f.loanrule_code_num BETWEEN 546 AND 554) THEN 'Brookline'
	WHEN (f.loanrule_code_num BETWEEN 68 AND 78 OR f.loanrule_code_num BETWEEN 555 AND 563) THEN 'Cambridge'
	WHEN (f.loanrule_code_num BETWEEN 79 AND 89 OR f.loanrule_code_num BETWEEN 564 AND 572) THEN 'Concord'
	WHEN (f.loanrule_code_num BETWEEN 90 AND 100 OR f.loanrule_code_num BETWEEN 573 AND 581) THEN 'Dedham'
	WHEN (f.loanrule_code_num BETWEEN 101 AND 111 OR f.loanrule_code_num BETWEEN 582 AND 590) THEN 'Dean'
	WHEN (f.loanrule_code_num BETWEEN 112 AND 122 OR f.loanrule_code_num BETWEEN 591 AND 599) THEN 'Dover'
	WHEN (f.loanrule_code_num BETWEEN 123 AND 133 OR f.loanrule_code_num BETWEEN 600 AND 608) THEN 'Framingham'
	WHEN (f.loanrule_code_num BETWEEN 134 AND 144 OR f.loanrule_code_num BETWEEN 609 AND 617) THEN 'Franklin'
	WHEN (f.loanrule_code_num BETWEEN 145 AND 155 OR f.loanrule_code_num BETWEEN 618 AND 626) THEN 'Framingham State'
	WHEN (f.loanrule_code_num BETWEEN 156 AND 166 OR f.loanrule_code_num BETWEEN 627 AND 635) THEN 'Holliston'
	WHEN (f.loanrule_code_num BETWEEN 167 AND 177 OR f.loanrule_code_num BETWEEN 636 AND 644) THEN 'Lasell'
	WHEN (f.loanrule_code_num BETWEEN 178 AND 188 OR f.loanrule_code_num BETWEEN 645 AND 653) THEN 'Lexington' 
	WHEN (f.loanrule_code_num BETWEEN 189 AND 199 OR f.loanrule_code_num BETWEEN 654 AND 662) THEN 'Lincoln'
	WHEN (f.loanrule_code_num BETWEEN 200 AND 210 OR f.loanrule_code_num BETWEEN 663 AND 671) THEN 'Maynard'
	WHEN (f.loanrule_code_num BETWEEN 222 AND 232 OR f.loanrule_code_num BETWEEN 681 AND 689) THEN 'Medford'
	WHEN (f.loanrule_code_num BETWEEN 233 AND 243 OR f.loanrule_code_num BETWEEN 690 AND 698) THEN 'Millis' 
	WHEN (f.loanrule_code_num BETWEEN 244 AND 254 OR f.loanrule_code_num BETWEEN 699 AND 707) THEN 'Medfield'
	WHEN (f.loanrule_code_num BETWEEN 266 AND 276 OR f.loanrule_code_num BETWEEN 717 AND 725) THEN 'Medway' 
	WHEN (f.loanrule_code_num BETWEEN 277 AND 287 OR f.loanrule_code_num BETWEEN 726 AND 734) THEN 'Natick'
	WHEN (f.loanrule_code_num BETWEEN 299 AND 309 OR f.loanrule_code_num BETWEEN 744 AND 752) THEN 'Needham' 
	WHEN (f.loanrule_code_num BETWEEN 310 AND 320 OR f.loanrule_code_num BETWEEN 753 AND 761) THEN 'Norwood' 
	WHEN (f.loanrule_code_num BETWEEN 321 AND 331 OR f.loanrule_code_num BETWEEN 762 AND 770) THEN 'Newton' 
	WHEN (f.loanrule_code_num BETWEEN 289 AND 298 OR f.loanrule_code_num BETWEEN 734 AND 743) THEN 'Olin'
	WHEN (f.loanrule_code_num BETWEEN 332 AND 342 OR f.loanrule_code_num BETWEEN 771 AND 779) THEN 'Somerville' 
	WHEN (f.loanrule_code_num BETWEEN 343 AND 353 OR f.loanrule_code_num BETWEEN 780 AND 788) THEN 'Stow' 
	WHEN (f.loanrule_code_num BETWEEN 354 AND 364 OR f.loanrule_code_num BETWEEN 789 AND 797) THEN 'Sudbury'
	WHEN (f.loanrule_code_num BETWEEN 365 AND 375 OR f.loanrule_code_num BETWEEN 798 AND 806) THEN 'Watertown' 
	WHEN (f.loanrule_code_num BETWEEN 376 AND 386 OR f.loanrule_code_num BETWEEN 807 AND 815) THEN 'Wellesley' 
	WHEN (f.loanrule_code_num BETWEEN 387 AND 397 OR f.loanrule_code_num BETWEEN 816 AND 824) THEN 'Winchester' 
	WHEN (f.loanrule_code_num BETWEEN 398 AND 408 OR f.loanrule_code_num BETWEEN 825 AND 833) THEN 'Waltham' 
	WHEN (f.loanrule_code_num BETWEEN 409 AND 419 OR f.loanrule_code_num BETWEEN 834 AND 842) THEN 'Woburn'
	WHEN (f.loanrule_code_num BETWEEN 420 AND 430 OR f.loanrule_code_num BETWEEN 843 AND 851) THEN 'Weston' 
	WHEN (f.loanrule_code_num BETWEEN 431 AND 441 OR f.loanrule_code_num BETWEEN 852 AND 860) THEN 'Westwood' 
	WHEN (f.loanrule_code_num BETWEEN 442 AND 452 OR f.loanrule_code_num BETWEEN 861 AND 869) THEN 'Wayland' 
	WHEN (f.loanrule_code_num BETWEEN 453 AND 463 OR f.loanrule_code_num BETWEEN 870 AND 878) THEN 'Pine Manor' 
	WHEN (f.loanrule_code_num BETWEEN 464 AND 474 OR f.loanrule_code_num BETWEEN 879 AND 887) THEN 'Regis' 
	WHEN (f.loanrule_code_num BETWEEN 475 AND 485 OR f.loanrule_code_num BETWEEN 888 AND 896) THEN 'Sherborn' 
	ELSE 'Other'
END AS checkout_location,
COALESCE(email.field_content,'') AS email

FROM
sierra_view.fine f
JOIN
patrons p
ON
f.patron_record_id = p.patron_record_id
JOIN
sierra_view.item_record i
ON
f.item_record_metadata_id = i.id AND i.location_code ~ '^ca\w{1}(j|y)'
JOIN
sierra_view.record_metadata rm
ON
f.patron_record_id = rm.id
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
LEFT JOIN
sierra_view.varfield email
ON
f.patron_record_id = email.record_id AND email.varfield_type_code = 'z'

WHERE f.charge_code IN ('3','5')
AND f.assessed_gmt::DATE BETWEEN '2024-01-01' AND '2024-05-31'-- CURRENT_DATE - INTERVAL '1 week'
ORDER BY 2,1