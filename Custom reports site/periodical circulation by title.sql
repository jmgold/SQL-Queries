/*
Jeremy Goldstein
Minuteman Library Network

Rolls up circulation figures for all issues of a title
*/
SELECT
*,
'' AS "PERIODICAL CIRCULATION BY TITLE",
'' AS "https://sic.minlib.net/reports/43"
FROM(
SELECT
{{title}} AS title,
/*
Options to account for annual circulation records with titles taking the form [Magazine name], [YYYY]
bp.best_title,
REPLACE(INITCAP(REGEXP_REPLACE(REPLACE(REPLACE(TRIM(bp.best_title),'.',''),',',''),'\s[\d]{4}(\s\w{3}\-\w{3})?$','')),'''S','''s')
*/
COUNT(i.id) AS total_issues,
SUM(i.last_year_to_date_checkout_total) AS last_year_checkout_total,
SUM(i.year_to_date_checkout_total) AS year_to_date_checkout_total,
SUM(i.checkout_total) AS checkout_total,
SUM(i.renewal_total) AS renewal_total,
SUM(i.checkout_total) + SUM(i.renewal_total) AS circulation_total,
SUM(i.use3_count) AS use_3_count,
SUM(i.copy_use_count) AS copy_use_count,
SUM(i.internal_use_count) AS internal_use_count,
MAX(i.last_checkout_gmt::DATE) AS last_checkout_date,
STRING_AGG(DISTINCT id2reckey(b.id)||'a',', ') AS bib_numbers

FROM
sierra_view.bib_record b
JOIN
sierra_view.bib_record_property bp
ON
b.id = bp.bib_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
b.id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id =i.id AND i.location_code ~ {{location}}
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.

WHERE
b.bcode3 = 'a' OR (bp.material_code = '3' AND i.itype_code_num IN ('10','158','107') AND i.item_status_code != 'j')

GROUP BY 1
ORDER BY 1)a