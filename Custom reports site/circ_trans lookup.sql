/*
Jeremy Goldstein
Minuteman Library Network

Staff interface for easily pulling data from circ_trans table
*/

SELECT 
c.transaction_gmt AS transaction_time,
c.application_name,
CASE
  WHEN C.op_code = 'o' THEN 'checkout'
  WHEN C.op_code = 'i' THEN 'checkin'
  WHEN C.op_code = 'n' THEN 'hold'
  WHEN C.op_code = 'nb' THEN 'bib hold'
  WHEN C.op_code = 'ni' THEN 'item hold'
  WHEN C.op_code = 'h' THEN 'hold with recall'
  WHEN C.op_code = 'hb' THEN 'hold recall bib'
  WHEN C.op_code = 'hi' THEN 'hold recall item'
  WHEN C.op_code = 'f' THEN 'filled hold'
  WHEN C.op_code = 'r' THEN 'renewal'
  WHEN C.op_code = 'u' THEN 'use count'
END AS transaction_type,
p.record_type_code||p.record_num||'a' AS patron_recoord,
p.barcode AS patron_barcode,
im.record_type_code||im.record_num||'a' AS item_record,
bm.record_type_code||bm.record_num||'a' AS bib_record,
C.stat_group_code_num AS stat_group,
C.due_date_gmt AS due_date,
C.count_type_code_num AS count_type,
C.itype_code_num AS itype,
C.icode1 AS scat,
C.item_location_code,
C.ptype_code,
C.patron_home_library_code AS patron_home_library,
C.loanrule_code_num AS loanrule,
i.call_number_norm AS call_number,
i.barcode AS item_barcode,
b.best_title_norm AS title,
b.material_code AS mat_type


FROM
sierra_view.circ_trans C
JOIN
sierra_view.item_record_property i
ON
C.item_record_id = i.item_record_id
JOIN
sierra_view.bib_record_property b
ON
C.bib_record_id = b.bib_record_id
JOIN
sierra_view.record_metadata im
ON
C.item_record_id = im.id
JOIN
sierra_view.record_metadata bm
ON
C.bib_record_id = bm.id
JOIN
sierra_view.patron_view p
ON
C.patron_record_id = p.id

WHERE
C.transaction_gmt BETWEEN {{start_time}} AND {{end_time}}
{{#if exclude_op}}AND C.op_code IN ({{op_code}}){{/if exclude_op}}
{{#if exclude_stat}}AND C.stat_group_code_num IN ({{stat_group}}){{/if exclude_stat}}
{{#if exclude_item_barcode}}AND i.barcode = {{barcode}}{{/if exclude_item_barcode}}
{{#if exclude_patron_barcode}}AND p.barcode = {{patron_barcode}}{{/if exclude_patron_barcode}}
{{#if exclude_title}}AND b.best_title_norm LIKE '%{{title}}%'{{/if exclude_title}}
{{#if exclude_location}}AND SUBSRING(C.item_location_code,1,3) ~ {{location}} {{/if exclude_location}}

ORDER BY 1