SELECT
DISTINCT id2reckey(pr.id)||'a' AS patron_number,
COALESCE(s.content,'') AS email

FROM
sierra_view.patron_record pr
JOIN
sierra_view.subfield s
ON
pr.id = s.record_id AND s.field_type_code = 'z' AND s.occ_num = 0
JOIN
sierra_view.checkout C
ON
pr.id = C.patron_record_id
JOIN
sierra_view.item_record i
ON
C.item_record_id = i.id AND i.itype_code_num IN ('150','151','167')

WHERE pr.ptype_code = '29'

ORDER BY 1