--9410 before 7/20
--5628 before 7/19
--2886 within 2019 and >0 checkouts
SELECT
DISTINCT s.content

FROM
sierra_view.patron_record p
JOIN
sierra_view.subfield s
ON
p.id = s.record_id AND s.field_type_code = 'z' AND s.occ_num = 0

WHERE (p.home_library_code = 'wlmz' OR p.ptype_code = '34')
AND DATE_PART('year',p.activity_gmt) = '2019' AND p.checkout_total > 0