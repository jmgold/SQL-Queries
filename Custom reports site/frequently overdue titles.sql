/*
Jeremy Goldstein
Minuteman Library Network

Produces list of the titles checked out at a given location that are overdue most frequently
Based on count of entries for a title in the fine and fine_paid tables
*/

WITH fine_checkout_location AS (
  SELECT
    f.item_record_metadata_id AS item_id,
    'f'||f.id AS id,
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
      WHEN f.loanrule_code_num BETWEEN 266 AND 276 OR f.loanrule_code_num BETWEEN 717 AND 725 THEN 'mww'
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

  FROM sierra_view.fine f

  WHERE f.charge_code IN  ('2','4','6')

  UNION

  SELECT
    fp.item_record_metadata_id AS item_id,
    'fp'||fp.id AS id,
    CASE
      WHEN fp.loan_rule_code_num BETWEEN 2 AND 12 OR fp.loan_rule_code_num BETWEEN 501 AND 509 THEN 'act'
      WHEN fp.loan_rule_code_num BETWEEN 13 AND 23 OR fp.loan_rule_code_num BETWEEN 510 AND 518 THEN 'arl'
      WHEN fp.loan_rule_code_num BETWEEN 24 AND 34 OR fp.loan_rule_code_num BETWEEN 519 AND 527 THEN 'ash'
      WHEN fp.loan_rule_code_num BETWEEN 35 AND 45 OR fp.loan_rule_code_num BETWEEN 528 AND 536 THEN 'bed'
      WHEN fp.loan_rule_code_num BETWEEN 46 AND 56 OR fp.loan_rule_code_num BETWEEN 537 AND 545 THEN 'blm'
      WHEN fp.loan_rule_code_num BETWEEN 57 AND 67 OR fp.loan_rule_code_num BETWEEN 546 AND 554 THEN 'brk'
      WHEN fp.loan_rule_code_num BETWEEN 68 AND 78 OR fp.loan_rule_code_num BETWEEN 555 AND 563 THEN 'cam'
      WHEN fp.loan_rule_code_num BETWEEN 79 AND 89 OR fp.loan_rule_code_num BETWEEN 564 AND 572 THEN 'con'
      WHEN fp.loan_rule_code_num BETWEEN 90 AND 100 OR fp.loan_rule_code_num BETWEEN 573 AND 581 THEN 'ddm'
      WHEN fp.loan_rule_code_num BETWEEN 101 AND 111 OR fp.loan_rule_code_num BETWEEN 582 AND 590 THEN 'dea'
      WHEN fp.loan_rule_code_num BETWEEN 112 AND 122 OR fp.loan_rule_code_num BETWEEN 591 AND 599 THEN 'dov'
      WHEN fp.loan_rule_code_num BETWEEN 123 AND 133 OR fp.loan_rule_code_num BETWEEN 600 AND 608 THEN 'fpl'
      WHEN fp.loan_rule_code_num BETWEEN 134 AND 144 OR fp.loan_rule_code_num BETWEEN 609 AND 617 THEN 'frk'
      WHEN fp.loan_rule_code_num BETWEEN 145 AND 155 OR fp.loan_rule_code_num BETWEEN 618 AND 626 THEN 'fst'
      WHEN fp.loan_rule_code_num BETWEEN 156 AND 166 OR fp.loan_rule_code_num BETWEEN 627 AND 635 THEN 'hol'
      WHEN fp.loan_rule_code_num BETWEEN 167 AND 177 OR fp.loan_rule_code_num BETWEEN 636 AND 644 THEN 'las'
      WHEN fp.loan_rule_code_num BETWEEN 178 AND 188 OR fp.loan_rule_code_num BETWEEN 645 AND 653 THEN 'lex'
      WHEN fp.loan_rule_code_num BETWEEN 189 AND 199 OR fp.loan_rule_code_num BETWEEN 654 AND 662 THEN 'lin'
      WHEN fp.loan_rule_code_num BETWEEN 200 AND 210 OR fp.loan_rule_code_num BETWEEN 663 AND 671 THEN 'may'
      WHEN fp.loan_rule_code_num BETWEEN 222 AND 232 OR fp.loan_rule_code_num BETWEEN 681 AND 689 THEN 'med'
      WHEN fp.loan_rule_code_num BETWEEN 233 AND 243 OR fp.loan_rule_code_num BETWEEN 690 AND 698 THEN 'mil'
      WHEN fp.loan_rule_code_num BETWEEN 244 AND 254 OR fp.loan_rule_code_num BETWEEN 699 AND 707 THEN 'mld'
      WHEN fp.loan_rule_code_num BETWEEN 266 AND 276 OR fp.loan_rule_code_num BETWEEN 717 AND 725 THEN 'mww'
      WHEN fp.loan_rule_code_num BETWEEN 277 AND 287 OR fp.loan_rule_code_num BETWEEN 726 AND 733 THEN 'nat'
      WHEN fp.loan_rule_code_num BETWEEN 289 AND 298 OR fp.loan_rule_code_num BETWEEN 734 AND 743 THEN 'oln'
      WHEN fp.loan_rule_code_num BETWEEN 299 AND 309 OR fp.loan_rule_code_num BETWEEN 744 AND 752 THEN 'nee'
      WHEN fp.loan_rule_code_num BETWEEN 310 AND 320 OR fp.loan_rule_code_num BETWEEN 753 AND 761 THEN 'nor'
      WHEN fp.loan_rule_code_num BETWEEN 321 AND 331 OR fp.loan_rule_code_num BETWEEN 762 AND 770 THEN 'ntn'
      WHEN fp.loan_rule_code_num BETWEEN 332 AND 342 OR fp.loan_rule_code_num BETWEEN 771 AND 779 THEN 'som'
      WHEN fp.loan_rule_code_num BETWEEN 343 AND 353 OR fp.loan_rule_code_num BETWEEN 780 AND 788 THEN 'sto'
      WHEN fp.loan_rule_code_num BETWEEN 354 AND 364 OR fp.loan_rule_code_num BETWEEN 789 AND 797 THEN 'sud'
      WHEN fp.loan_rule_code_num BETWEEN 365 AND 375 OR fp.loan_rule_code_num BETWEEN 798 AND 806 THEN 'wat'
      WHEN fp.loan_rule_code_num BETWEEN 376 AND 386 OR fp.loan_rule_code_num BETWEEN 807 AND 815 THEN 'wel'
      WHEN fp.loan_rule_code_num BETWEEN 387 AND 397 OR fp.loan_rule_code_num BETWEEN 816 AND 824 THEN 'win'
      WHEN fp.loan_rule_code_num BETWEEN 398 AND 408 OR fp.loan_rule_code_num BETWEEN 825 AND 833 THEN 'wlm'
      WHEN fp.loan_rule_code_num BETWEEN 409 AND 419 OR fp.loan_rule_code_num BETWEEN 834 AND 842 THEN 'wob'
      WHEN fp.loan_rule_code_num BETWEEN 420 AND 430 OR fp.loan_rule_code_num BETWEEN 843 AND 851 THEN 'wsn'
      WHEN fp.loan_rule_code_num BETWEEN 431 AND 441 OR fp.loan_rule_code_num BETWEEN 852 AND 860 THEN 'wwd'
      WHEN fp.loan_rule_code_num BETWEEN 442 AND 452 OR fp.loan_rule_code_num BETWEEN 861 AND 869 THEN 'wyl'
      WHEN fp.loan_rule_code_num BETWEEN 453 AND 463 OR fp.loan_rule_code_num BETWEEN 870 AND 878 THEN 'pmc'
      WHEN fp.loan_rule_code_num BETWEEN 464 AND 474 OR fp.loan_rule_code_num BETWEEN 879 AND 887 THEN 'reg'
      WHEN fp.loan_rule_code_num BETWEEN 475 AND 485 OR fp.loan_rule_code_num BETWEEN 888 AND 896 THEN 'shr'
      Else 'Other'
    END AS checkout_location

  FROM sierra_view.fines_paid fp

  WHERE fp.charge_type_code IN  ('2','4','6')
)

SELECT
  *,
  '' AS "FREQUENTLY OVERDUE TITLES",
  '' AS "https://sic.minlib.net/reports/80"
FROM (
  SELECT
    b.best_title AS title,
    SPLIT_PART(b.best_author,', ',1)||', '||REPLACE(TRANSLATE(SPLIT_PART(b.best_author,', ',2),'.',','),',','') AS author,
    COUNT(DISTINCT fc.id) AS overdue_count,
    STRING_AGG(DISTINCT rm.record_type_code||rm.record_num||'a',', ') AS bib_records

  FROM sierra_view.bib_record_property b
  JOIN sierra_view.bib_record_item_record_link l
    ON b.bib_record_id = l.bib_record_id
  JOIN fine_checkout_location fc
    ON l.item_record_id = fc.item_id
  JOIN sierra_view.record_metadata rm
    ON b.bib_record_id = rm.id

  WHERE b.material_code IN ({{mat_type}})
  --mat_type will take a list of material type values such as 'a','b','c'
    AND fc.checkout_location ~ '{{location}}'
    --location will take the form ^oln, which in this example looks for all locations starting with the string oln.

  GROUP BY 1,2
  ORDER BY 3 DESC
  LIMIT {{qty}}
)a