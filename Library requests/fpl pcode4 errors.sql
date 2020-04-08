SELECT
id2reckey(p.id)||'a' AS patron_record,
p.pcode4,
pc.name AS pcode4_label

FROM
sierra_view.patron_record p
JOIN
sierra_view.user_defined_pcode4_myuser pc
ON
p.pcode4::varchar = pc.code
WHERE
p.patron_agency_code_num = '18'
AND
(p.pcode4 < 1101 OR p.pcode4 > 1110)