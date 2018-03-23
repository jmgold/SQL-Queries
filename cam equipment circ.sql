--Cambridge circ_trans data stripped of patron info for project run by Reinhard Engels

SELECT
c.transaction_gmt,
c.application_name,
c.op_code,
b.best_title,
b.material_code,
id2reckey(c.bib_record_id)||'a' as bib_num,
id2reckey(c.item_record_id)||'a' as item_num,
i.barcode,
c.stat_group_code_num,
c.due_date_gmt,
c.count_type_code_num,
c.itype_code_num,
c.icode1,
c.item_location_code,
c.loanrule_code_num

FROM
sierra_view.circ_trans c
JOIN
sierra_view.bib_record_property b
ON
c.bib_record_id = b.bib_record_id and b.material_code IN ('q','r','v')
JOIN
sierra_view.item_record_property i
ON
c.item_record_id = i.item_record_id
WHERE
item_agency_code_num = 3