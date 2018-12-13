--Jeremy Goldstein
--Minuteman Library network

--Framingham circ_trans data limited to library of things materials for Carol Ames

SELECT
c.transaction_gmt,
c.application_name,
c.op_code,
b.best_title,
b.material_code,
id2reckey(c.bib_record_id)||'a' as bib_num,
id2reckey(c.item_record_id)||'a' as item_num,
i.barcode,
i.call_number_norm,
c.stat_group_code_num,
c.due_date_gmt,
c.count_type_code_num,
c.itype_code_num,
c.icode1,
c.item_location_code,
c.loanrule_code_num,
md5(CAST(c.patron_record_id AS varchar))

FROM
sierra_view.circ_trans c
JOIN
sierra_view.bib_record_property b
ON
c.bib_record_id = b.bib_record_id
JOIN
sierra_view.item_record_property i
ON
c.item_record_id = i.item_record_id

WHERE
c.itype_code_num IN ('245', '246', '250', '251', '252', '253')
AND
c.icode1 = '138'
AND
c.item_agency_code_num = '18'